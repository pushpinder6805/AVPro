import Component from "@glimmer/component";
import { get } from "@ember/helper";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { service } from "@ember/service";
import ShareTopicModal from "discourse/components/modal/share-topic";
import TopicExcerpt from "discourse/components/topic-list/topic-excerpt";
import TopicLink from "discourse/components/topic-list/topic-link";
import UnreadIndicator from "discourse/components/topic-list/unread-indicator";
import TopicPostBadges from "discourse/components/topic-post-badges";
import TopicStatus from "discourse/components/topic-status";
import UserLink from "discourse/components/user-link";
import avatar from "discourse/helpers/avatar";
import icon from "discourse/helpers/d-icon";
import discourseTags from "discourse/helpers/discourse-tags";
import formatDate from "discourse/helpers/format-date";
import { wantsNewWindow } from "discourse/lib/intercept-click";
import { i18n } from "discourse-i18n";

export default class Item extends Component {
  @service currentUser;
  @service modal;

  get newDotText() {
    return this.currentUser?.trust_level > 0
      ? ""
      : i18n("filters.new.lower_title");
  }

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
    <div {{on "click" this.openTopic}} class="custom-topic-layout">

      {{!-- LEFT CONTENT --}}
      <div class="custom-topic-layout_body">

        {{!-- AUTHOR ROW --}}
        <div class="custom-topic-author">
          <UserLink @user={{@outletArgs.topic.creator}}>
            {{avatar @outletArgs.topic.creator imageSize="small"}}
            <span class="username">
              @{{@outletArgs.topic.creator.username}}
            </span>
          </UserLink>

          <span class="topic-time">
            {{formatDate
              @outletArgs.topic.createdAt
              format="relative"
              noTitle="true"
            }}
          </span>
        </div>

        {{!-- TITLE --}}
        <h2 class="topic-title">
          <TopicStatus @topic={{@outletArgs.topic}} />

          <TopicLink
            @topic={{@outletArgs.topic}}
            class="raw-link raw-topic-link"
          />

          <UnreadIndicator @topic={{@outletArgs.topic}} />

          {{#if @outletArgs.showTopicPostBadges}}
            <TopicPostBadges
              @unreadPosts={{@outletArgs.topic.unread_posts}}
              @unseen={{@outletArgs.topic.unseen}}
              @newDotText={{this.newDotText}}
              @url={{@outletArgs.topic.lastUnreadUrl}}
            />
          {{/if}}
        </h2>

        {{!-- EXCERPT (ALWAYS VISIBLE) --}}
        <div class="custom-topic-layout_excerpt">
          <TopicExcerpt @topic={{@outletArgs.topic}} />
        </div>

        {{!-- TAGS --}}
        <div class="link-bottom-line">
          {{discourseTags
            @outletArgs.topic
            mode="list"
            tagsForUser=@outletArgs.tagsForUser
          }}
        </div>

        {{!-- META BAR --}}
        <div class="custom-topic-layout_bottom-bar">
          <span>
            {{icon "heart"}}
            {{@outletArgs.topic.like_count}}
          </span>

          <span>
            {{icon "reply"}}
            {{@outletArgs.topic.replyCount}}
          </span>

          <span {{on "click" this.share}} class="share-toggle">
            {{icon "link"}}
            Share
          </span>
        </div>

      </div>

      {{!-- RIGHT IMAGE --}}
      {{#if @outletArgs.topic.thumbnails}}
        <div class="custom-topic-layout_image">
          <img
            src={{get @outletArgs "topic.thumbnails.0.url"}}
            loading="lazy"
          />
        </div>
      {{/if}}

    </div>
  </template>
}

