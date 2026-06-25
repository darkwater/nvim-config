; extends

(
 (block_mapping_pair
   key: (flow_node
          (plain_scalar
            (string_scalar) @_key))
   value: (block_node
            (block_scalar) @injection.content))
 (#eq? @_key "run")
 (#set! injection.language "bash")
 )

(
 (block_mapping_pair
   key: (flow_node
          (plain_scalar
            (string_scalar) @_key))
   value: (flow_node
            (plain_scalar) @injection.content))
 (#eq? @_key "run")
 (#set! injection.language "bash")
 )
