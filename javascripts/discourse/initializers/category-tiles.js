import { apiInitializer } from "discourse/lib/api";

export default apiInitializer("1.29.0", (api) => {
  api.onPageChange((url) => {
    if (!url.startsWith("/categories")) return;

    requestAnimationFrame(() => {
      const defaultList = document.querySelector(".categories-list");
      if (!defaultList) return;

      // Hide default list
      defaultList.style.display = "none";

      // Prevent duplicate render
      if (document.querySelector(".category-tiles-wrapper")) return;

      // ✅ Supported source in Discourse 3.6+
      const categories = window.Discourse?.Site?.currentProp("categories");
      if (!categories || !categories.length) return;

      const wrapper = document.createElement("div");
      wrapper.className = "category-tiles-wrapper";

      categories.forEach((cat) => {
        if (cat.read_restricted) return;

        const image = cat.custom_fields?.tile_image || "";
        const desc =
          cat.custom_fields?.tile_description ||
          cat.description_excerpt ||
          "";

        const tags = (cat.custom_fields?.tile_tags || "")
          .split(",")
          .map(t => t.trim())
          .filter(Boolean);

        const tile = document.createElement("a");
        tile.className = "category-tile";
        tile.href = `/c/${cat.slug}/${cat.id}`;

        tile.innerHTML = `
          <div class="category-tile-image"
               style="background-image:url('${image}')"></div>

          <div class="category-tile-content">
            <h3>${cat.name}</h3>
            <p>${desc}</p>
            <div class="category-tile-tags">
              ${tags.map(t => `<span class="tag-pill">${t}</span>`).join("")}
            </div>
          </div>
        `;

        wrapper.appendChild(tile);
      });

      defaultList.parentElement.appendChild(wrapper);
    });
  });
});

