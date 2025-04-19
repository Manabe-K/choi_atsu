import { application } from "./application"

import FlatpickrController from "./flatpickr_controller"
application.register("flatpickr", FlatpickrController)

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
