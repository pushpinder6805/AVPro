import Component from "@glimmer/component";
import { action } from "@ember/object";
import didInsert from "@ember/render-modifiers/modifiers/did-insert";
import willDestroy from "@ember/render-modifiers/modifiers/will-destroy";
import { service } from "@ember/service";
import { bind } from "discourse/lib/decorators";
import { wantsNewWindow } from "discourse/lib/intercept-click";
import DiscourseURL from "discourse/lib/url";

export default class ClickableTopicCard extends Component {
  @service site;

  @bind
  clickHandler(event) {
    const targetElement = event.target;
    const topic = this.args.outletArgs.topic;

    const clickTargets = [
      "topic-list-data",
      "link-bottom-line",
      "topic-list-item",
      "topic-card__excerpt",
      "topic-card__excerpt-text",
      "topic-card__metadata",
      "topic-card__likes",
      "topic-card__op",
    ];

    if (this.site.mobileView) {
      clickTargets.push("topic-item-metadata");
    }

    if (clickTargets.some((t) => targetElement.closest(`.${t}`))) {
      if (wantsNewWindow(event)) {
        return true;
      }

      // ✅ Supported navigation
      DiscourseURL.routeTo(topic.lastUnreadUrl || topic.url);
      event.preventDefault();
      return false;
    }
  }

  @action
  registerClickHandler(element) {
    element.parentElement.addEventListener("click", this.clickHandler);
  }

  @action
  removeClickHandler(element) {
    element.parentElement.removeEventListener("click", this.clickHandler);
  }

  <template>
    <div
      class="hidden"
      {{didInsert this.registerClickHandler}}
      {{willDestroy this.removeClickHandler}}
    ></div>
  </template>
}

