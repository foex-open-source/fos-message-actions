CREATE OR REPLACE PACKAGE BODY COM_FOS_MESSAGE_ACTIONS
IS
function render
    ( p_dynamic_action apex_plugin.t_dynamic_action
    , p_plugin         apex_plugin.t_plugin
    )
return apex_plugin.t_dynamic_action_render_result
as
    l_result apex_plugin.t_dynamic_action_render_result;

    --general attributes
    l_action       p_dynamic_action.attribute_01%type := p_dynamic_action.attribute_01;
    l_message_type p_dynamic_action.attribute_02%type := p_dynamic_action.attribute_02;
    l_message      p_dynamic_action.attribute_03%type := p_dynamic_action.attribute_03;
    l_js_code      p_dynamic_action.attribute_04%type := p_dynamic_action.attribute_04;
    l_escape       boolean                            := p_dynamic_action.attribute_05 = 'Y';

    -- error configuration
    l_err_display_location apex_t_varchar2 := apex_string.split(p_dynamic_action.attribute_06, ':');
    l_err_associated_item  p_dynamic_action.attribute_07%type := p_dynamic_action.attribute_07;

    -- success configuration
    l_autodismiss boolean                            := p_dynamic_action.attribute_08 = 'Y';
    l_duration    p_dynamic_action.attribute_09%type := p_dynamic_action.attribute_09;

begin

    if apex_application.g_debug then
        apex_plugin_util.debug_dynamic_action
            ( p_dynamic_action => p_dynamic_action
            , p_plugin         => p_plugin
            );
    end if;

    apex_json.initialize_clob_output;
    apex_json.open_object;

    if l_action in ('show-page-success', 'show-error') then
        if l_message_type =  'static' then
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
            apex_json.write('actionType', 'showPageSuccess');
            apex_json.write('escape'    , l_escape);

            apex_json.open_object('config');
            apex_json.write('duration', l_duration);
            apex_json.close_object;

        when 'hide-page-success' then
            apex_json.write('actionType', 'hidePageSuccess');

        when 'show-error' then
            apex_json.write('actionType', 'showError');
            apex_json.write('escape'    , l_escape);

            apex_json.open_object('config');
            apex_json.write('location', l_err_display_location);
            apex_json.write('pageItem', l_err_associated_item);
            apex_json.close_object;

        when 'clear-errors' then
            apex_json.write('actionType', 'clearErrors');

    end case;

    apex_json.close_object;

    l_result.javascript_function := 'function(){FOS.message.action(this, ' || apex_json.get_clob_output || ');}';

    apex_json.free_output;
    return l_result;
end;
END COM_FOS_MESSAGE_ACTIONS;
/


