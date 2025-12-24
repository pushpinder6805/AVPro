import Component from "@glimmer/component";
import { htmlSafe } from "@ember/template";

export default class TopicListItem extends Component {
  get excerpt() {
    return htmlSafe(this.args.topic.excerpt || "");
  }

  get imageUrl() {
    return this.args.topic.image_url;
  }

  get author() {
    return this.args.topic.creator?.username;
  }
}

