import { apiInitializer } from "discourse/lib/api";

export default apiInitializer("1.29.0", (api) => {
  api.onPageChange((url) => {
    if (!url.startsWith("/categories")) return;

    requestAnimationFrame(() => {
      const outlet = document.querySelector(".categories-list");
      if (!outlet) return;

      outlet.style.display = "none";

      if (document.querySelector(".category-tiles-wrapper")) return;

      const categories =
        api.container.lookup("service:store").peekAll("category");

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
          .map((t) => t.trim())
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

      outlet.parentElement.appendChild(wrapper);
    });
  });
});

