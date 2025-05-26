import { application } from "./application"

import FlatpickrEventController from "./flatpickr_event_controller"
application.register("flatpickr-event", FlatpickrEventController)

import FlatpickrDeadlineController from "./flatpickr_deadline_controller"
application.register("flatpickr-deadline", FlatpickrDeadlineController)

import FormAnimationController from "./form_animation_controller"
application.register("form-animation", FormAnimationController)

import FormCapacityController from "./form_capacity_controller"
application.register("form-capacity", FormCapacityController)

import FormUserSearchController from "./form_user_search_controller"
application.register("form-user-search", FormUserSearchController)

import ProfileImageController from "./profile_image_controller"
application.register("profile-image", ProfileImageController)

import UserTagInputController from "./user_tag_input_controller"
application.register("user-tag-input", UserTagInputController)

import EventTagInputController from "./event_tag_input_controller"
application.register("event-tag-input", EventTagInputController)

import EventCardController from "./event_card_controller"
application.register("event-card", EventCardController)

import MenuToggleController from "./menu_toggle_controller"
application.register("menu-toggle", MenuToggleController)

import FlashMessageController from "./flash_message_controller"
application.register("flash-message", FlashMessageController)