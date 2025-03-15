import $ from "jquery";
window.$ = window.jQuery = $;

import Rails from "@rails/ujs";
Rails.start();

import "bootstrap";
import "bootstrap/dist/css/bootstrap.min.css";

import "./custom/sidebar";

import "@fortawesome/fontawesome-free/css/all.min.css";
import "@fortawesome/fontawesome-free/js/all.min.js";

import "datatables.net-bs5";
import "datatables.net-buttons-bs5";
import "datatables.net-responsive-bs5";
import "datatables.net-bs5/css/dataTables.bootstrap5.min.css";

import "./custom/tables";

import "./stylesheets/styleadmin.css";import "@hotwired/turbo-rails"
