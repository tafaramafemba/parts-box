import { createConsumer } from "@rails/actioncable";

export const consumer = createConsumer();

const channels = require.context('.', true, /_channel\.js$/);
channels.keys().forEach(channels);
