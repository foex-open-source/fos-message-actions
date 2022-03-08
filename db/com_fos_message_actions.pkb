create or replace package body com_fos_message_actions
as

-- =============================================================================
--
--  FOS = FOEX Open Source (fos.world), by FOEX GmbH, Austria (www.foex.at)
--
--  This plug-in gives you a dynamic action to show and hide page success
--  and error messages.
--
--  License: MIT
--
--  GitHub: https://github.com/foex-open-source/fos-message-actions
--
-- =============================================================================

function render
  ( p_dynamic_action apex_plugin.t_dynamic_action
  , p_plugin         apex_plugin.t_plugin
  )
return apex_plugin.t_dynamic_action_render_result
as
    l_result apex_plugin.t_dynamic_action_render_result;

    --general attributes
    l_action               p_dynamic_action.attribute_01%type := p_dynamic_action.attribute_01;
    l_message_type         p_dynamic_action.attribute_02%type := p_dynamic_action.attribute_02;
    l_message              p_dynamic_action.attribute_03%type := p_dynamic_action.attribute_03;
    l_js_code              p_dynamic_action.attribute_04%type := p_dynamic_action.attribute_04;
    l_escape               boolean                            := p_dynamic_action.attribute_05 = 'Y';
    l_autodismiss          boolean                            := p_dynamic_action.attribute_08 = 'Y';
    l_clear_items          apex_t_varchar2                    := case when p_dynamic_action.attribute_11 is not null then apex_string.split(p_dynamic_action.attribute_11, ',') else apex_t_varchar2() end;

    -- Javascript Initialization Code
    l_init_js_fn           varchar2(32767)                    := nvl(apex_plugin_util.replace_substitutions(p_dynamic_action.init_javascript_code), 'undefined');

    -- error configuration
    l_err_display_location apex_t_varchar2                    := apex_string.split(nvl(p_dynamic_action.attribute_06, 'inline:page'), ':');
    l_err_associated_item  p_dynamic_action.attribute_07%type := p_dynamic_action.attribute_07;
    l_clear_errors         boolean                            := p_dynamic_action.attribute_10 = 'Y';

    -- success configuration
    l_duration             p_dynamic_action.attribute_09%type := p_dynamic_action.attribute_09;

    -- message types to clear
    l_clear_success        boolean                            := instr(nvl(p_dynamic_action.attribute_12,' '), 'success') > 0;
    l_clear_error          boolean                            := instr(nvl(p_dynamic_action.attribute_12,' '), 'error'  ) > 0;
    l_hide_after           pls_integer                        := p_dynamic_action.attribute_13;


begin
    -- standard debugging intro, but only if necessary
    if apex_application.g_debug and substr(:DEBUG,6) >= 6
    then
        apex_plugin_util.debug_dynamic_action
          ( p_plugin         => p_plugin
          , p_dynamic_action => p_dynamic_action
          );
    end if;

    -- create a JS function call passing all settings as a JSON object
    --
    --   FOS.message.action(this, {
    --       "message": function() {
    --           return (this.data);
    --       },
    --       "actionType": "showPageSuccess",
    --       "escape": true,
    --       "config": {
    --           "duration": "3000"
    --       }
    --   });
    apex_json.initialize_clob_output;
    apex_json.open_object;

    if l_action in ('show-page-success', 'show-error')
    then
        if l_message_type =  'static'
        then
            apex_json.write('message', l_message);
        else
            apex_json.write_raw
              ( p_name  => 'message'
              , p_value => case l_message_type
                               when 'javascript-expression' then
                                  'function(){return (' || l_js_code || ');}'
                               when 'javascript-function-body' then
                                   'function(){' || l_js_code || '}'
                           end
              );
        end if;
    end if;

    case l_action
        when 'show-page-success' then
            apex_json.write('actionType' , 'showPageSuccess');
            apex_json.write('escape'     , l_escape);

            apex_json.open_object('config');
            apex_json.write('autoDismiss', l_autodismiss);
            if l_autodismiss then
                apex_json.write('duration', l_duration * 1000);
            end if;
            apex_json.close_object;

        when 'hide-page-success' then
            apex_json.write('actionType'  , 'hidePageSuccess');

        when 'show-error' then
            apex_json.write('actionType'  , 'showError');
            apex_json.write('escape'      , l_escape);

            apex_json.open_object('config');
            apex_json.write('autoDismiss' , l_autodismiss);

            if l_autodismiss
            then
                apex_json.write('duration', l_duration * 1000);
            end if;

            apex_json.write('location'    , l_err_display_location);
            apex_json.write('pageItem'    , trim(both ',' from replace(l_err_associated_item, ' ','')));
            apex_json.write('clearErrors' , l_clear_errors);
            apex_json.close_object;

        when 'clear-errors' then
            apex_json.write('actionType'  , 'clearErrors');
            apex_json.write('pageItems'   , l_clear_items);
        when 'clear-message' then
            apex_json.write('actionType'  , 'clearMessage');
            apex_json.write('clearSuccess', l_clear_success);
            apex_json.write('clearError'  , l_clear_error);
            apex_json.write('hideAfter'   , l_hide_after * 1000);
    end case;

    apex_json.close_object;

    l_result.javascript_function := 'function(){FOS.message.action(this, ' || apex_json.get_clob_output || ', '|| l_init_js_fn || ');}';

    apex_json.free_output;

    return l_result;
end render;

end;
/


