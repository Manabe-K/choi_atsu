import { application } from "./application"

import FormAnimationController from "./form_animation_controller"
application.register("form-animation", FormAnimationController)

import FormCapacityController from "./form_capacity_controller"
application.register("form-capacity", FormCapacityController)

import FormUserSearchController from "./form_user_search_controller"
application.register("form-user-search", FormUserSearchController)