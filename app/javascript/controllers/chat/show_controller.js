import consumer from "channels/consumer";
import { Controller } from "@hotwired/stimulus";
import ApplicationController from "../application_controller";

// Connects to data-controller="chat--show"
export default class extends ApplicationController {
  static values = { uid: Number, id: Number };
  static targets = [
    "messages",
    "form",
    "list",
    "message",
    "older_button",
    "div",
  ];

  constructor(e) {
    super(e);
    this.chat = consumer.subscriptions;
    this.chatList = null; // for search. It holds all list
  }

  connect() {
    const received = (data) => this.received(data);

    let cmd = { channel: "ChatChannel" };
    if (this.idValue !== undefined) {
      cmd["id"] = this.idValue;
    }

    this.chat.create(cmd, {
      connected() {
        console.log("connected to chat");
      },
      disconnected() {
        // Called when the subscription has been terminated by the server
      },
      received: received,
    });
  }

  searchChat(event) {
    if (this.chatList === null) {
      this.chatList = this.listTarget.children;
    }

    if (value === "") {
      var chats = $(".chats");

      var len = this.chatList.length;
      for (var i = 0; i < len; i++) {
        const e = this.chatList[i];
        chats.append(e);
      }
    }
  }

  /**  for internal purpose **/
  received(data) {
    let response = JSON.parse(data);

    if (response.action === "prepend") {
      this.loadMore(response);
    } else if (response.action == "append") {
      const senderId = response.user.id;
      const isOwner = senderId == this.uidValue;
      if (this.idValue !== undefined) {
        this.appendMessage(response, isOwner);
      }
      this.updateSideBar(response, isOwner);
    } else if (response.action === "remove") {
    } else if (response.action === "update") {
      // innert html
    }
  }

  loadMore(data) {
    if (data.pagy.next !== null) {
      this.older_buttonTarget.href = data.pagy.next_url;
    } else {
      this.divTarget.classList.add("hidden");
    }

    var messages = data.messages;
    var len = messages.length;
    for (var i = 0; i < len; i++) {
      var msg = messages[i];
      const isOwner = msg.user.id == this.uidValue;
      // Remember: flex-col-reveres

      if (isOwner) {
        this.insertHTML(this.outgoingMessageCard(msg), "beforeend");
      } else {
        this.insertHTML(this.incomingMessageCard(msg), "beforeend");
      }
    }
  }

  // add to list
  appendMessage(response, isOwner) {
    // it show in reverse order. Don't forget
    if (isOwner) {
      this.insertHTML(this.outgoingMessageCard(response), "afterbegin");
    } else {
      this.insertHTML(this.incomingMessageCard(response), "afterbegin");
    }
  }

  //
  updateSideBar(response, isOwner) {
    const isMobile = window.innerWidth == 634;
    const isShow = this.idValue !== undefined;
    // in chat show page, if it's mobile, you won't get list of chats in side bar.
    // but in chat#index page either mobile or destop you will see chat list.
    if(isMobile && isShow) {
      return;
    }

    const msgId = `chat_${response.message.chat_id}_message`;
    const senderDomId = `chat_${response.message.chat_id}_sender`;
    var senderMsg = document.getElementById(msgId);
    if (!isOwner) {
      var sender = document.getElementById(senderDomId);
      if (sender !== null) {
        sender.innerHTML = `${response.user.full_name}: `;
      }
    }
    if(senderMsg !== null) {
      senderMsg.innerHTML = response.message.body.slice(0, 15);
    }
  }

  outgoingMessageCard(data) {
    return `
    <div id="message_${data.message.id}" class="my-1 mr-2">
      <div class="p-1 w-full flex flex-row-reverse">
        <div class="w-message">
          <div class="flex justify-end">
            <p class="body mr-2 py-3 px-4 bg-primary dark:bg-dark-primary rounded-bl-3xl rounded-tl-3xl rounded-tr-xl text-onPrimary dark:text-dark-onPrimary">${data.message.body}</p>
          </div>
          <p class="txt-txtSecondary dark:text-dark-txtSecondary text-right text-sm mr-2">${data.message.created_at}</p>
        </div>
      </div>
    </div>`;
  }

  incomingMessageCard(data) {
    return `
    <div class="flex mx-1">
      <div class="w-8 h-full flex">
        <img class="w-full h-8 rounded-full object-cover" src="${data.user.profile}">
      </div>
      <div class="w-message">
        <div class="max-w-message">
          <p class="body text-link dark:text-dark-link text-sm font-semibold ml-3 mb-1">${data.user.full_name}</p>
          <p class="inline-flex ml-2 py-3 px-4 bg-gray-400 dark:bg-gray-700 rounded-br-3xl rounded-tr-3xl rounded-tl-xl text-white">${data.message.body}</p>
        </div>
        <p class="txt-txtSecondary dark:text-dark-txtSecondary text-sm w-full ml-2">${data.message.created_at}</p>
      </div>
    </div>`;
  }

  insertHTML(html, pos) {
    this.messagesTarget.insertAdjacentHTML(pos, html);
  }

  clearInboxSection() {
    this.messageTarget.value = "";
  }

  scrollToLast(id) {}
}
