import Component from "@glimmer/component";
import { apiInitializer } from "discourse/lib/api";
import ClickableTopicCard from "../components/clickable-topic-card";
import TopicExcerpt from "../components/topic-excerpt";
import TopicMetadata from "../components/topic-metadata";
import TopicOp from "../components/topic-op";
import TopicTagsMobile from "../components/topic-tags-mobile";
import TopicThumbnail from "../components/topic-thumbnail";

export default apiInitializer("1.39.0", (api) => {
  const site = api.container.lookup("service:site");

  // Render clickable card wrapper
  api.renderInOutlet("above-topic-list-item", ClickableTopicCard);

  // Main topic content
  api.renderInOutlet(
    "topic-list-main-link-bottom",
    class extends Component {
      static shouldRender(_, context) {
        return context.siteSettings.glimmer_topic_list_mode !== "disabled";
      }

      <template>
        <TopicOp @topic={{@outletArgs.topic}} />
        <TopicExcerpt @topic={{@outletArgs.topic}} />
        <TopicMetadata @topic={{@outletArgs.topic}} />
      </template>
    }
  );

  // Add CSS classes via value transformers (SUPPORTED)
  api.registerValueTransformer(
    "topic-list-class",
    ({ value }) => [...value, "topic-cards-list"]
  );

  const classNames = ["topic-card"];

  if (settings.set_card_max_height) {
    classNames.push("has-max-height");
  }

  api.registerValueTransformer(
    "topic-list-item-class",
    ({ value }) => [...value, ...classNames]
  );

  api.registerValueTransformer("topic-list-item-mobile-layout", () => false);

  api.registerValueTransformer("topic-list-columns", ({ value: columns }) => {
    columns.add("thumbnail", { item: TopicThumbnail }, { before: "topic" });

    if (site.mobileView) {
      columns.add(
        "tags-mobile",
        { item: TopicTagsMobile },
        { before: "thumbnail" }
      );
    }

    return columns;
  });
});

