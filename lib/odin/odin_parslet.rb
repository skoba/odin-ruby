require 'parslet'

module OpenEHR
  module Parser
    class ODINParslet < Parslet::Parser
      root :v_odin_text
      rule(:v_odin_text) do
        spaces >> sym_parchetype.maybe >>
          (attr_vals | complex_object_block)
      end

      rule(:attr_vals) do
        attr_val >>
          (str(';').maybe >> spaces >> attr_val >> spaces).repeat
      end

      rule(:attr_val) { attr_id >> sym_eq >> object_block }

      rule(:attr_id) { v_attribute_identifier >> space.repeat }

      rule(:object_block) do
        complex_object_block |
          primitive_object_block # |
          # object_reference_block |
          # (sym_start_dblock >> sym_end_dblock)
      end

      rule(:complex_object_block) { single_attr_object_block | container_attr_object_block }

      rule(:container_attr_object_block) do
        type_identifier.maybe >> untyped_container_attr_object_block
      end

      rule(:untyped_container_attr_object_block) do
        container_attr_object_block_head >> keyed_objects >> sym_end_dblock
      end

      rule(:container_attr_object_block_head) { sym_start_dblock }

      rule(:keyed_objects) { keyed_object.repeat(1) }

      rule(:keyed_object) { object_key >> sym_eq >> object_block }

      rule(:object_key) { str('[') >> primitive_value >> str(']') >> space.repeat }
      rule(:single_attr_object_block) do
        type_identifier.maybe >> untyped_single_attr_object_block
      end

      rule(:untyped_single_attr_object_block) do
        single_attr_object_complex_head >> attr_vals >> sym_end_dblock
      end

      rule(:single_attr_object_complex_head) { sym_start_dblock }

      rule(:primitive_object_block) do
        type_identifier.maybe >> untyped_primitive_object_block
      end

      rule(:untyped_primitive_object_block) do
        sym_start_dblock >> primitive_object >> sym_end_dblock
      end

      rule(:primitive_object) do
        term_code_list_value |
          term_code |
          primitive_list_value |
          primitive_interval_value |
          primitive_value
      end 

      rule(:primitive_value) { boolean_value | string_value }

      rule(:primitive_list_value) do
        #        integer_list_value | real_list_value | boolean_list_value | character_list_value | date_list_value | time_list_value | date_time_list_value | duration_list_value | 
        string_list_value
      end

      rule(:primitive_interval_value) do
        integer_interval_value |
        real_interval_value |
        date_interval_value |
        time_interval_value |
        date_time_interval_value |
        duration_interval_value
      end

      rule(:type_identifier) { str('(').maybe >> v_type_identifier | v_generic_type_identifier >> str(')').maybe }

      rule(:string_value) { v_string }

      rule(:string_list_value) do
        v_string >>
        (str(',') >> space.repeat >> v_string).repeat >> space.repeat >>
        sym_list_continue.maybe
      end

      rule(:integer_value) do
        v_integer |
          str('+') >> v_integer |
          str('-') >> v_integer
      end

      rule(integer_value)
      rule(:boolean_value) { sym_true | sym_false }
      rule(:object_reference_block) { sym_start_dblock >> absolute_path_object_value >> sym_end_dblock }

      # path
      rule(:absolute_path_object_value) { absolute_path_list | absolute_path }

      rule(:absolute_path_list) do
        absolute_path >>
          ((str(',') >> space.repeat >> absolute_path).repeat(1) |
           (str(',') >> space.repeat >> sym_list_continue))
      end

      rule(:absolute_path) do
        ((absolute_path >> str('/') >> relative_path) |
         (str('/') >> relative_path) |
         str('/'))
      end

      rule(:relative_path) do
        path_segment >> (str('/') >> path_segment).repeat
      end

      rule(:term_code) { v_qualified_term_code_ref }
      rule(:term_code_list_value) { term_code >> ((str(',') >> term_code).repeat(1)| sym_list_continue)}

      # definitions
      rule(:idchar) { match '[a-zA-Z0-9_]' }
      rule(:namechar) { match['a-zA-Z0-9._\-'] }
      rule(:namechar_paren) { match['a-zA-Z0-9._\-()'] }
      # symbols
      rule(:sym_eq) { str('=') >> space.repeat }
      rule(:sym_start_dblock) { str('<') >> spaces }
      rule(:sym_end_dblock) { str('>') >> spaces }
      rule(:sym_list_continue) { str('...') >> spaces }

      rule(:sym_true) do
        (match['T']|match['t']) >> (match['R']|match['r']) >> (match['U']|match['u']) >> (match['E']|match['e'])
      end

      rule(:sym_false) do
        (match['F']|match['f']) >> (match['A']|match['a']) >> (match['L']|match['l']) >> (match['S']|match['s']) >> (match['E']|match['e'])
      end
      rule(:sym_parchetype) { str('(P_ARCHETYPE)') >> space.repeat }

      rule(:v_qualified_term_code_ref) do
        str('[') >>
          namechar_paren.repeat(1) >> str('::') >> namechar.repeat(1) >>
          str(']')
      end
      rule(:v_type_identifier) { match('[A-Z]') >> idchar.repeat }
      rule(:v_generic_type_identifier) { match('[A-Z]') >> idchar.repeat >> str('<') >> match('[a-zA-Z0-9,_<>]').repeat(1) >> str('>') }
      rule(:v_attribute_identifier) { match['_a-z'] >> idchar.repeat }
      rule(:v_string) { str('"') >> (str('\"')| match('[^"]')).repeat >> str('"') }
      rule(:spaces) { space.repeat >> comment.repeat >> space.repeat }
      rule(:comment) { str('--') >> match['^\n'].repeat >> match('\n') }
      rule(:space) { match('\s') }
    end
  end
end
