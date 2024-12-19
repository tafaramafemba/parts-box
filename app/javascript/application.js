import { createConsumer } from "@rails/action";
window.App = { cable: createConsumer() };
import "controllers"
import "@hotwired/-rails"
import "@hotwired/turbo-rails"
