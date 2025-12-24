import Component from "@glimmer/component";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { service } from "@ember/service";
import ShareTopicModal from "discourse/components/modal/share-topic";
import TopicLink from "discourse/components/topic-list/topic-link";
import TopicStatus from "discourse/components/topic-status";
import UnreadIndicator from "discourse/components/topic-list/unread-indicator";
import TopicExcerpt from "discourse/components/topic-list/topic-excerpt";
import UserLink from "discourse/components/user-link";
import avatar from "discourse/helpers/avatar";
import icon from "discourse/helpers/d-icon";
import formatDate from "discourse/helpers/format-date";
import { wantsNewWindow } from "discourse/lib/intercept-click";

export default class Item extends Component {
  @service modal;

  @action
  openTopic(event) {
    if (
      (event.target.nodeName === "A" && !event.target.closest(".raw-link")) ||
      event.target.closest(".badge-wrapper")
    ) {
      return;
    }

    const { navigateToTopic, topic } = this.args.outletArgs;

    if (wantsNewWindow(event)) {
      window.open(topic.lastUnreadUrl, "_blank");
    } else {
      navigateToTopic(topic, topic.lastUnreadUrl);
    }
  }

  @action
  share(event) {
    event.stopPropagation();
    this.modal.show(ShareTopicModal, {
      model: { topic: this.args.outletArgs.topic },
    });
  }

  <template>
    {{! template-lint-disable no-invalid-interactive }}
    <div {{on "click" this.openTopic}} class="custom-topic-card">

      {{!-- LEFT CONTENT --}}
      <div class="custom-topic-card_body">

        {{!-- AUTHOR ROW (ONLY avatar + username + time) --}}
        <div class="custom-topic-author">
          <UserLink @user={{@outletArgs.topic.creator}}>
            {{avatar @outletArgs.topic.creator imageSize="small"}}
            <span class="username">
              @{{@outletArgs.topic.creator.username}}
            </span>
          </UserLink>

          <span class="topic-time">
            {{formatDate
              @outletArgs.topic.created_at
              format="relative"
              noTitle="true"
            }}
          </span>
        </div>

        {{!-- TITLE --}}
        <h2 class="custom-topic-title">
          <TopicStatus @topic={{@outletArgs.topic}} />
          <TopicLink
            @topic={{@outletArgs.topic}}
            class="raw-link raw-topic-link"
          />
          <UnreadIndicator @topic={{@outletArgs.topic}} />
        </h2>

        {{!-- EXCERPT (ALWAYS) --}}
        <div class="custom-topic-excerpt">
          <TopicExcerpt @topic={{@outletArgs.topic}} />
        </div>

        {{!-- META BAR --}}
        <div class="custom-topic-meta">
          <span>
            {{icon "heart"}}
            {{@outletArgs.topic.like_count}}
          </span>

          <span>
            {{icon "reply"}}
            {{@outletArgs.topic.reply_count}}
          </span>

          <span {{on "click" this.share}} class="share">
            {{icon "link"}} Share
          </span>
        </div>

      </div>

      {{!-- RIGHT IMAGE --}}
      {{#if @outletArgs.topic.image_url}}
        <div class="custom-topic-image">
          <img src={{@outletArgs.topic.image_url}} loading="lazy" />
        </div>
      {{/if}}

    </div>
  </template>
}

