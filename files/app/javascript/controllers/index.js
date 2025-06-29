// Load all the controllers within this directory and all subdirectories.
// Controller files must be named *_controller.js or *_controller.ts.

import { Application } from "@hotwired/stimulus"

const application = Application.start()

import AdminHelloController from "./admin_hello_controller"
application.register("admin-hello", AdminHelloController)
