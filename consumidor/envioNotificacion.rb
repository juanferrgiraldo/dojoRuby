#!/usr/bin/env ruby
require 'bunny'

connection = Bunny.new(automatically_recover: false)
connection.start

channel = connection.create_channel
queue = channel.queue('colaDojo', durable: true)

channel.prefetch(5)
puts ' [*] Waiting for messages. To exit press CTRL+C'

begin
queue.subscribe(manual_ack: true, block: true) do |delivery_info, _properties, body|
puts " [x] Enviando notificación... '#{body}'"
# imitate some work
sleep body.count('.').to_i
sleep(1)
puts ' [x] Done'
channel.ack(delivery_info.delivery_tag)
end
rescue Interrupt => _
connection.close
end
