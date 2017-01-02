module Idocrase
  VERSION = {{`(cat #{__DIR__}/../../shard.yml | sed -ne "/^version/s/version: //p") || true`.stringify.chomp}}
end
