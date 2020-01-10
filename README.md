# rabbitmq-consumer-coldfusion

1. Create 2 queues in RabbitMQ - "test-a" and "test-b"
2. Run application (update credentials in Application.cfc)
3. Publish message to "test-a" queue
4. The message will be copied to "test-b" queue twice (a) without properties and (b) with properties
5. Obviously 4b will fail

Call to `index.cfm?reinit` will reconnect application to the messaging queue.
