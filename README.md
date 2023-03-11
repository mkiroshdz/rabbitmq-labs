This repo contains some examples of RabbitMQ producers and consumers:

### Credentials
The scripts the data in credentials.yml to authenticate to the RabbitMQ instance.

### Schema
The exchanges script integrates protobuffers to encode and decode data. The schema definition lives [here](https://github.com/mkiroshdz/rabbitmq-labs/tree/main/schema)

### [Hello](https://github.com/mkiroshdz/rabbitmq-labs/tree/main/hello)
#### Summary
This example produces and consume a simple hello message.
#### Usage
``` 
    ruby hello/producer.rb # To produce the message
    ruby hello/consumer.rb # To consume the message
```

### [Exchanges](https://github.com/mkiroshdz/rabbitmq-labs/tree/main/exchanges)
#### Summary
Allows to produce messages using a particular exchange and consume from particular queues.
#### Usage
```
    ruby exchanges/producer.rb -h
    ruby -r <schema_protobuffs_file> exchanges/producer.rb -b '{"idx": 1}' -f json -r 'rentals.new' -e topic:amq.topic -s payload.json -k Count
    ruby exchanges/consumer.rb <queue_name> <schema_klass>
```


