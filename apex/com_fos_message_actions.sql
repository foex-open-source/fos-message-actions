prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_190200 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2019.10.04'
,p_release=>'19.2.0.00.18'
,p_default_workspace_id=>1620873114056663
,p_default_application_id=>102
,p_default_id_offset=>0
,p_default_owner=>'FOS_MASTER_WS'
);
end;
/

prompt APPLICATION 102 - FOS Dev - Plugin Master
--
-- Application Export:
--   Application:     102
--   Name:            FOS Dev - Plugin Master
--   Exported By:     FOS_MASTER_WS
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 61118001090994374
--     PLUGIN: 134108205512926532
--     PLUGIN: 1039471776506160903
--     PLUGIN: 547902228942303344
--     PLUGIN: 412155278231616931
--     PLUGIN: 1200087692794692554
--     PLUGIN: 461352325906078083
--     PLUGIN: 13235263798301758
--     PLUGIN: 37441962356114799
--     PLUGIN: 1846579882179407086
--     PLUGIN: 8354320589762683
--     PLUGIN: 50031193176975232
--     PLUGIN: 106296184223956059
--     PLUGIN: 35822631205839510
--     PLUGIN: 2674568769566617
--     PLUGIN: 14934236679644451
--     PLUGIN: 2600618193722136
--     PLUGIN: 2657630155025963
--     PLUGIN: 284978227819945411
--     PLUGIN: 56714461465893111
--     PLUGIN: 98648032013264649
--     PLUGIN: 455014954654760331
--     PLUGIN: 98504124924145200
--   Manifest End
--   Version:         19.2.0.00.18
--   Instance ID:     250144500186934
--

begin
  -- replace components
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/dynamic_action/com_fos_message_actions
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(106296184223956059)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'COM.FOS.MESSAGE_ACTIONS'
,p_display_name=>'FOS - Message Actions'
,p_category=>'EXECUTE'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_javascript_file_urls=>'#PLUGIN_FILES#js/script#MIN#.js'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- =============================================================================',
'--',
'--  FOS = FOEX Open Source (fos.world), by FOEX GmbH, Austria (www.foex.at)',
'--',
'--  This plug-in gives you a dynamic action to show and hide page success',
'--  and error messages.',
'--',
'--  License: MIT',
'--',
'--  GitHub: https://github.com/foex-open-source/fos-message-actions',
'--',
'-- =============================================================================',
'',
'function render',
'  ( p_dynamic_action apex_plugin.t_dynamic_action',
'  , p_plugin         apex_plugin.t_plugin',
'  )',
'return apex_plugin.t_dynamic_action_render_result',
'as',
'    l_result apex_plugin.t_dynamic_action_render_result;',
'',
'    --general attributes',
'    l_action               p_dynamic_action.attribute_01%type := p_dynamic_action.attribute_01;',
'    l_message_type         p_dynamic_action.attribute_02%type := p_dynamic_action.attribute_02;',
'    l_message              p_dynamic_action.attribute_03%type := p_dynamic_action.attribute_03;',
'    l_js_code              p_dynamic_action.attribute_04%type := p_dynamic_action.attribute_04;',
'    l_escape               boolean                            := p_dynamic_action.attribute_05 = ''Y'';',
'    l_autodismiss          boolean                            := p_dynamic_action.attribute_08 = ''Y'';',
'    l_clear_items          apex_t_varchar2                    := case when p_dynamic_action.attribute_11 is not null then apex_string.split(p_dynamic_action.attribute_11, '','') else apex_t_varchar2() end;',
'    ',
'    -- Javascript Initialization Code',
'    l_init_js_fn           varchar2(32767)                    := nvl(apex_plugin_util.replace_substitutions(p_dynamic_action.init_javascript_code), ''undefined'');',
'',
'    -- error configuration',
'    l_err_display_location apex_t_varchar2                    := apex_string.split(nvl(p_dynamic_action.attribute_06, ''inline:page''), '':'');',
'    l_err_associated_item  p_dynamic_action.attribute_07%type := p_dynamic_action.attribute_07;',
'    l_clear_errors         boolean                            := p_dynamic_action.attribute_10 = ''Y'';',
'    ',
'    -- success configuration',
'    l_duration             p_dynamic_action.attribute_09%type := p_dynamic_action.attribute_09;',
'',
'begin',
'    -- standard debugging intro, but only if necessary',
'    if apex_application.g_debug ',
'    then',
'        apex_plugin_util.debug_dynamic_action',
'          ( p_plugin         => p_plugin',
'          , p_dynamic_action => p_dynamic_action ',
'          );',
'    end if;',
'',
'    -- create a JS function call passing all settings as a JSON object',
'    --',
'    --   FOS.message.action(this, {',
'    --       "message": function() {',
'    --           return (this.data);',
'    --       },',
'    --       "actionType": "showPageSuccess",',
'    --       "escape": true,',
'    --       "config": {',
'    --           "duration": "3000"',
'    --       }',
'    --   });',
'    apex_json.initialize_clob_output;',
'    apex_json.open_object;',
'    ',
'    if l_action in (''show-page-success'', ''show-error'') ',
'    then',
'        if l_message_type =  ''static'' ',
'        then',
'            apex_json.write(''message'', l_message);',
'        else',
'            apex_json.write_raw',
'              ( p_name  => ''message''',
'              , p_value => case l_message_type',
'                               when ''javascript-expression'' then',
'                                  ''function(){return ('' || l_js_code || '');}''',
'                               when ''javascript-function-body'' then',
'                                   ''function(){'' || l_js_code || ''}''',
'                           end',
'              );',
'        end if;',
'    end if;',
'    ',
'    case l_action',
'        when ''show-page-success'' then',
'            apex_json.write(''actionType'' , ''showPageSuccess'');',
'            apex_json.write(''escape''     , l_escape);',
'',
'            apex_json.open_object(''config'');',
'            apex_json.write(''autoDismiss'', l_autodismiss);',
'            if l_autodismiss then',
'                apex_json.write(''duration'', l_duration * 1000);',
'            end if;',
'            apex_json.close_object;',
'        ',
'        when ''hide-page-success'' then',
'            apex_json.write(''actionType''  , ''hidePageSuccess'');',
'',
'        when ''show-error'' then',
'            apex_json.write(''actionType''  , ''showError'');    ',
'            apex_json.write(''escape''      , l_escape);',
'',
'            apex_json.open_object(''config'');',
'            apex_json.write(''autoDismiss'' , l_autodismiss);',
'            ',
'            if l_autodismiss ',
'            then',
'                apex_json.write(''duration'', l_duration * 1000);',
'            end if;',
'            ',
'            apex_json.write(''location''    , l_err_display_location);',
'            apex_json.write(''pageItem''    , trim(both '','' from replace(l_err_associated_item, '' '','''')));',
'            apex_json.write(''clearErrors'' , l_clear_errors);            ',
'            apex_json.close_object;',
'        ',
'        when ''clear-errors'' then',
'            apex_json.write(''actionType''  , ''clearErrors'');',
'            apex_json.write(''pageItems''   , l_clear_items);',
'    end case;',
'',
'    apex_json.close_object;',
'',
'    l_result.javascript_function := ''function(){FOS.message.action(this, '' || apex_json.get_clob_output || '', ''|| l_init_js_fn || '');}'';',
'',
'    apex_json.free_output;',
'',
'    return l_result;',
'end render;'))
,p_api_version=>2
,p_render_function=>'render'
,p_standard_attributes=>'INIT_JAVASCRIPT_CODE'
,p_substitute_attributes=>false
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>The <strong>FOS - Message Actions</strong> dynamic action plug-in is an easy and declarative way to deal with APEX success and error messages. It can show errors inline with fields and in notifications, as well as showing page level messages that '
||'look the same as regular APEX page notifications. Internally we use the same Javascript API that APEX provides to show these messages.</p>',
'<p>The message can be a static string with optional page item substitutions, or derived from a Javascript expression or function.</p>',
'<p>You also have control over how escaping should be performed on the message. Either entirely, or only for certain page items if your message contains HTML markup.</p>'))
,p_version_identifier=>'21.1.0'
,p_about_url=>'https://fos.world'
,p_plugin_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Settings for the FOS browser extension',
'@fos-auto-return-to-page',
'@fos-auto-open-files:js/script.js'))
,p_files_version=>180
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(106296321175956059)
,p_plugin_id=>wwv_flow_api.id(106296184223956059)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Action'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'show-page-success'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'<p>The action to be performed.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(106296739546956060)
,p_plugin_attribute_id=>wwv_flow_api.id(106296321175956059)
,p_display_sequence=>10
,p_display_value=>'Show Page Success'
,p_return_value=>'show-page-success'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Displays a success notification.</p>',
'<p>Note that if one already exists, it will be replaced.</p>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(106297234300956060)
,p_plugin_attribute_id=>wwv_flow_api.id(106296321175956059)
,p_display_sequence=>20
,p_display_value=>'Hide Page Success'
,p_return_value=>'hide-page-success'
,p_help_text=>'<p>Hides the success notification if one is present.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(106297771013956060)
,p_plugin_attribute_id=>wwv_flow_api.id(106296321175956059)
,p_display_sequence=>30
,p_display_value=>'Show Error'
,p_return_value=>'show-error'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Displays an error notification.</p>',
'<p>It can be displayed on page, targeted to a specific item, or both.</p>',
'<p>By default, error notifications are added to a stack, which means you can call this action multiple times to display various errors. If you wish to clear the stack and only display this error, make sure to call the "Clear Errors" action first.</p>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(106298240781956060)
,p_plugin_attribute_id=>wwv_flow_api.id(106296321175956059)
,p_display_sequence=>40
,p_display_value=>'Clear Errors'
,p_return_value=>'clear-errors'
,p_help_text=>'<p>Clears all current error notifications.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(106298738074956061)
,p_plugin_id=>wwv_flow_api.id(106296184223956059)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Message Type'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'static'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(106296321175956059)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'show-page-success,show-error'
,p_lov_type=>'STATIC'
,p_help_text=>'<p>The source type of the message to be displayed.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(106299651352956061)
,p_plugin_attribute_id=>wwv_flow_api.id(106298738074956061)
,p_display_sequence=>10
,p_display_value=>'Static Text'
,p_return_value=>'static'
,p_help_text=>'<p>A static value. This value can also reference page items.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(106300196328956061)
,p_plugin_attribute_id=>wwv_flow_api.id(106298738074956061)
,p_display_sequence=>20
,p_display_value=>'JavaScript Expression'
,p_return_value=>'javascript-expression'
,p_help_text=>'<p>A JavaScript Expression</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(106299149124956061)
,p_plugin_attribute_id=>wwv_flow_api.id(106298738074956061)
,p_display_sequence=>30
,p_display_value=>'JavaScript Function Body'
,p_return_value=>'javascript-function-body'
,p_help_text=>'<p>A JavaScript function body returning a string</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(106300691934956061)
,p_plugin_id=>wwv_flow_api.id(106296184223956059)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Message'
,p_attribute_type=>'TEXTAREA'
,p_is_required=>true
,p_is_translatable=>true
,p_depending_on_attribute_id=>wwv_flow_api.id(106298738074956061)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'static'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>The message to be displayed.</p>',
'<p>You can reference any page item by using the "&PAGE_ITEM." format. To escape the page item value, either set "Escape Special Characters" to "Yes", or use the "&PAGE_ITEM!HTML." substitution format.</p>',
'<p><b>Note: </b> The substitution will be done in the browser, with the current page item values.</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(106301007337956062)
,p_plugin_id=>wwv_flow_api.id(106296184223956059)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'JavaScript Code'
,p_attribute_type=>'JAVASCRIPT'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(106298738074956061)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'javascript-expression,javascript-function-body'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<h4>JavaScript Expression</h4>',
'<pre>apex.item(''P1_COUNT'').getValue() + " records added"</pre>',
'',
'<h4>JavaScript Function Body</h4>',
'<pre>var count = apex.item(''P1_COUNT'').getValue();',
'return count + " record" + (count != 1 ? "s" : "") + " added";',
'</pre>'))
,p_help_text=>'<p>JavaScript Code resulting in a string.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(106301461436956062)
,p_plugin_id=>wwv_flow_api.id(106296184223956059)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Escape Special Characters'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(106296321175956059)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'show-page-success,show-error'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>To prevent Cross-Site Scripting (XSS) attacks, always set this attribute to "Yes". If you need to render HTML tags in the message, set this attribute to "No".</p>',
'<p><b>Note:</b> You can still escape only certain page items, by using the &PAGE_ITEM!HTML. substitution string format.</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(106301836655956062)
,p_plugin_id=>wwv_flow_api.id(106296184223956059)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Display Location'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'inline:page'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(106296321175956059)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'show-error'
,p_lov_type=>'STATIC'
,p_help_text=>'<p>Select where the error message is displayed. Error messages can be displayed inline underneath an Associated Item label and/or in a Notification area, defined as part of the page template.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(106302243709956062)
,p_plugin_attribute_id=>wwv_flow_api.id(106301836655956062)
,p_display_sequence=>10
,p_display_value=>'Inline with Field and in Notification'
,p_return_value=>'inline:page'
,p_help_text=>'<p>Both inline with a specific Page Item and in a notification</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(106302738806956062)
,p_plugin_attribute_id=>wwv_flow_api.id(106301836655956062)
,p_display_sequence=>20
,p_display_value=>'Inline with Field'
,p_return_value=>'inline'
,p_help_text=>'<p>Inline with a specific Page Item</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(106303222164956063)
,p_plugin_attribute_id=>wwv_flow_api.id(106301836655956062)
,p_display_sequence=>30
,p_display_value=>'Inline in Notification'
,p_return_value=>'page'
,p_help_text=>'<p>In a notification</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(106303783556956063)
,p_plugin_id=>wwv_flow_api.id(106296184223956059)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Associated Item(s)'
,p_attribute_type=>'PAGE ITEMS'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(106301836655956062)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'inline,inline:page'
,p_help_text=>'<p>Displays the error notification inline with a page item. You can select multiple page items to associate the same message with them.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(106304120249956063)
,p_plugin_id=>wwv_flow_api.id(106296184223956059)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'Autodismiss'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(106296321175956059)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'show-page-success,show-error'
,p_help_text=>'<p>By default, success notifications are displayed until the user closes them. Set this attribute to "Yes" to auto dismiss the notification after a specific amount of time.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(106304549951956063)
,p_plugin_id=>wwv_flow_api.id(106296184223956059)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'Autodismiss After'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'10'
,p_unit=>'seconds'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(106304120249956063)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>'<p>The time in seconds until the notification will be dismissed.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(106304970855956063)
,p_plugin_id=>wwv_flow_api.id(106296184223956059)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>100
,p_prompt=>'Clear Other Errors'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(106296321175956059)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'show-error'
,p_help_text=>'<p>Enable this option to clear any existing errors before showing your new error message.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(106305353478956064)
,p_plugin_id=>wwv_flow_api.id(106296184223956059)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>110
,p_prompt=>'Page Item(s)'
,p_attribute_type=>'PAGE ITEMS'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(106296321175956059)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'clear-errors'
,p_help_text=>'<p>Enter a list of page item(s) that you would like to clear errors for. Leave this attribute blank if you want to clear all errors.</p>'
);
wwv_flow_api.create_plugin_std_attribute(
 p_id=>wwv_flow_api.id(106308731252956066)
,p_plugin_id=>wwv_flow_api.id(106296184223956059)
,p_name=>'INIT_JAVASCRIPT_CODE'
,p_is_required=>false
,p_depending_on_has_to_exist=>true
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>',
'function(config){',
'    config.message = ''New Message'';',
'}',
'</pre>'))
,p_help_text=>'Javascript initialization function which allows you to override any settings right before the dynamic action is invoked.'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A20676C6F62616C732061706578202A2F0A0A76617220464F53203D2077696E646F772E464F53207C7C207B7D3B0A464F532E6D657373616765203D20464F532E6D657373616765207C7C207B7D3B0A0A2F2A2A0A202A20546869732066756E637469';
wwv_flow_api.g_varchar2_table(2) := '6F6E2069732073686F77696E67206F7220686964696E672074686520676976656E2073756363657373206F72206572726F72206D6573736167652E0A202A0A202A2040706172616D207B6F626A6563747D2020206461436F6E7465787420202020202020';
wwv_flow_api.g_varchar2_table(3) := '20202020202020202020202020202044796E616D696320416374696F6E20636F6E746578742061732070617373656420696E20627920415045580A202A2040706172616D207B6F626A6563747D202020636F6E6669672020202020202020202020202020';
wwv_flow_api.g_varchar2_table(4) := '2020202020202020202020436F6E66696775726174696F6E206F626A65637420686F6C64696E6720746865206D65737361676520636F6E66696775726174696F6E0A202A2040706172616D207B737472696E677D202020636F6E6669672E6D6573736167';
wwv_flow_api.g_varchar2_table(5) := '652020202020202020202020202020202020537472696E67206F72204A532066756E6374696F6E2072657475726E696E6720746865206D65737361676520746578740A202A2040706172616D207B737472696E677D202020636F6E6669672E616374696F';
wwv_flow_api.g_varchar2_table(6) := '6E5479706520202020202020202020202020204F6E65206F663A2073686F7750616765537563636573737C6869646550616765537563636573737C73686F774572726F727C636C6561724572726F72730A202A2040706172616D207B626F6F6C65616E7D';
wwv_flow_api.g_varchar2_table(7) := '20205B636F6E6669672E6573636170655D202020202020202020202020202020205768657468657220746F2065736361706520746865206D65737361676520746578740A202A2040706172616D207B6E756D6265727D2020205B636F6E6669672E636F6E';
wwv_flow_api.g_varchar2_table(8) := '6669672E6475726174696F6E5D20202020202020416D6F756E74206F66206D696C6C697365636F6E647320616674657220746861742074686520706167652073756363657373206D6573736167652073686F756C64206175746F6D61746963616C6C7920';
wwv_flow_api.g_varchar2_table(9) := '6265206469736D69737365640A202A2040706172616D207B737472696E677D2020205B636F6E6669672E6C6F636174696F6E5D2020202020202020202020202020576865726520746F20646973706C617920746865206572726F72206D6573736167652C';
wwv_flow_api.g_varchar2_table(10) := '206F6E20706167652C20696E6C696E652C20626F74680A202A2040706172616D207B737472696E677D2020205B636F6E6669672E706167654974656D5D20202020202020202020202020204E616D65206F66207468652070616765206974656D20776869';
wwv_flow_api.g_varchar2_table(11) := '636820746865206572726F72206D6573736167652073686F756C64206265206173736F63696174656420776974680A202A2040706172616D207B737472696E677D2020205B636F6E6669672E706167654974656D735D202020202020202020202020204E';
wwv_flow_api.g_varchar2_table(12) := '616D65206F66207468652070616765206974656D7320776869636820746865206572726F72206D6573736167652073686F756C6420626520636C656172656420666F720A202A2040706172616D207B66756E6374696F6E7D205B696E6974466E5D202020';
wwv_flow_api.g_varchar2_table(13) := '20202020202020202020202020202020202020204A61766173637269707420496E697469616C697A6174696F6E20436F64652046756E6374696F6E2C2069742063616E20626520756E646566696E65640A2A2F0A464F532E6D6573736167652E61637469';
wwv_flow_api.g_varchar2_table(14) := '6F6E203D2066756E6374696F6E20286461436F6E746578742C20636F6E6669672C20696E6974466E29207B0A0A2020202076617220706C7567696E4E616D65203D2027464F53202D204D65737361676520416374696F6E73273B0A20202020617065782E';
wwv_flow_api.g_varchar2_table(15) := '64656275672E696E666F28706C7567696E4E616D652C20636F6E666967293B0A0A202020202F2F20416C6C6F772074686520646576656C6F70657220746F20706572666F726D20616E79206C617374202863656E7472616C697A656429206368616E6765';
wwv_flow_api.g_varchar2_table(16) := '73207573696E67204A61766173637269707420496E697469616C697A6174696F6E20436F64652073657474696E670A2020202069662028696E6974466E20696E7374616E63656F662046756E6374696F6E29207B0A2020202020202020696E6974466E2E';
wwv_flow_api.g_varchar2_table(17) := '63616C6C286461436F6E746578742C20636F6E666967293B0A202020207D0A0A20202020766172206D6573736167653B0A0A202020202F2F205265706C6163696E6720737562737469747574696E6720737472696E677320616E64206573636170696E67';
wwv_flow_api.g_varchar2_table(18) := '20746865206D6573736167650A20202020696620285B2773686F775061676553756363657373272C202773686F774572726F72275D2E696E6465784F6628636F6E6669672E616374696F6E5479706529203E202D3129207B0A0A20202020202020206966';
wwv_flow_api.g_varchar2_table(19) := '2028636F6E6669672E6D65737361676520696E7374616E63656F662046756E6374696F6E29207B0A2020202020202020202020206D657373616765203D20636F6E6669672E6D6573736167652E63616C6C286461436F6E74657874293B0A202020202020';
wwv_flow_api.g_varchar2_table(20) := '20207D20656C7365207B0A2020202020202020202020206D657373616765203D20636F6E6669672E6D6573736167653B0A20202020202020207D0A0A20202020202020202F2F20205265706C6163696E6720737562737469747574696F6E20737472696E';
wwv_flow_api.g_varchar2_table(21) := '67730A20202020202020202F2F2020576520646F6E27742065736361706520746865206D6573736167652062792064656661756C742E205765206C65742074686520646576656C6F70657220646563696465207768657468657220746F20657363617065';
wwv_flow_api.g_varchar2_table(22) := '0A20202020202020202F2F20207468652077686F6C65206D6573736167652C206F72206A75737420696E76696475616C2070616765206974656D73207669612024504147455F4954454D2148544D4C2E0A2020202020202020696620286D657373616765';
wwv_flow_api.g_varchar2_table(23) := '29207B0A2020202020202020202020206D657373616765203D20617065782E7574696C2E6170706C7954656D706C617465286D6573736167652C207B0A2020202020202020202020202020202064656661756C7445736361706546696C7465723A206E75';
wwv_flow_api.g_varchar2_table(24) := '6C6C0A2020202020202020202020207D293B0A20202020202020207D20656C7365207B0A2020202020202020202020202F2F20496E206361736520746865206D65737361676520697320656D7074792C2077652077696C6C2065786974206E6F77206173';
wwv_flow_api.g_varchar2_table(25) := '207468657265206973206E6F7468696E6720746F2073686F770A2020202020202020202020202F2F2077652077696C6C206C6F672061206465627567206D65737361676520746F20696E64696361746520746865206D65737361676520697320626C616E';
wwv_flow_api.g_varchar2_table(26) := '6B2E205468697320697320746865200A2020202020202020202020202F2F2073616D65206265686176696F7572206173206F7572204E6F74696669636174696F6E7320706C75672D696E0A202020202020202020202020617065782E64656275672E6C6F';
wwv_flow_api.g_varchar2_table(27) := '6728636F6E6669672E706C7567696E4E616D65202B20273A20746865206D65737361676520697320656D7074792C20736F206974206973206E6F742073686F776E2127293B0A20202020202020202020202072657475726E3B0A20202020202020207D0A';
wwv_flow_api.g_varchar2_table(28) := '0A20202020202020202F2F20457363617065205370656369616C2043686172616374657273206174747269627574650A202020202020202069662028636F6E6669672E65736361706529207B0A2020202020202020202020206D657373616765203D2061';
wwv_flow_api.g_varchar2_table(29) := '7065782E7574696C2E65736361706548544D4C286D657373616765293B0A20202020202020207D0A202020207D0A0A202020207377697463682028636F6E6669672E616374696F6E5479706529207B0A202020202020202063617365202773686F775061';
wwv_flow_api.g_varchar2_table(30) := '676553756363657373273A0A202020202020202020202020464F532E6D6573736167652E73686F775061676553756363657373286D6573736167652C20636F6E6669672E636F6E666967293B0A202020202020202020202020627265616B3B0A20202020';
wwv_flow_api.g_varchar2_table(31) := '20202020636173652027686964655061676553756363657373273A0A202020202020202020202020464F532E6D6573736167652E68696465506167655375636365737328293B0A202020202020202020202020627265616B3B0A20202020202020206361';
wwv_flow_api.g_varchar2_table(32) := '7365202773686F774572726F72273A0A202020202020202020202020464F532E6D6573736167652E73686F774572726F72286D6573736167652C20636F6E6669672E636F6E666967293B0A202020202020202020202020627265616B3B0A202020202020';
wwv_flow_api.g_varchar2_table(33) := '2020636173652027636C6561724572726F7273273A0A202020202020202020202020464F532E6D6573736167652E636C6561724572726F727328636F6E6669672E706167654974656D73293B0A202020202020202020202020627265616B3B0A20202020';
wwv_flow_api.g_varchar2_table(34) := '7D0A7D3B0A0A464F532E6D6573736167652E73686F775061676553756363657373203D2066756E6374696F6E20286D6573736167652C20636F6E66696729207B0A0A202020202F2F2073746F7020616E79206C696E676572696E67206175746F20646973';
wwv_flow_api.g_varchar2_table(35) := '6D697373657320696620616E206578697374696E67206D6573736167652068617320616C7265616479206265656E2073686F776E0A202020207661722063757272656E7454696D656F75744964203D20464F532E6D6573736167652E73686F7750616765';

wwv_flow_api.g_varchar2_table(36) := '537563636573732E74696D656F757449643B0A202020206966202863757272656E7454696D656F7574496429207B0A2020202020202020636C656172496E74657276616C2863757272656E7454696D656F75744964293B0A202020202020202064656C65';
wwv_flow_api.g_varchar2_table(37) := '746520464F532E6D6573736167652E73686F7750616765537563636573732E74696D656F757449643B0A202020207D0A0A202020202F2F20616E79206573636170696E6720697320617373756D656420746F2068617665206265656E20646F6E65206279';
wwv_flow_api.g_varchar2_table(38) := '206E6F770A20202020617065782E6D6573736167652E73686F775061676553756363657373286D657373616765293B0A0A202020202F2F207365747570206F75722074696D657220746F206175746F206469736D69737320746865206D65737361676520';
wwv_flow_api.g_varchar2_table(39) := '61667465722058207365636F6E64730A2020202069662028636F6E6669672E6475726174696F6E29207B0A2020202020202020464F532E6D6573736167652E73686F7750616765537563636573732E74696D656F75744964203D2073657454696D656F75';
wwv_flow_api.g_varchar2_table(40) := '742866756E6374696F6E202829207B0A202020202020202020202020464F532E6D6573736167652E68696465506167655375636365737328293B0A20202020202020207D2C20636F6E6669672E6475726174696F6E293B0A202020207D0A7D3B0A0A464F';
wwv_flow_api.g_varchar2_table(41) := '532E6D6573736167652E686964655061676553756363657373203D2066756E6374696F6E202829207B0A20202020617065782E6D6573736167652E68696465506167655375636365737328293B0A7D3B0A0A464F532E6D6573736167652E73686F774572';
wwv_flow_api.g_varchar2_table(42) := '726F72203D2066756E6374696F6E20286D6573736167652C20636F6E66696729207B0A0A202020202F2F2073746F7020616E79206C696E676572696E67206175746F206469736D697373657320696620616E206578697374696E67206D65737361676520';
wwv_flow_api.g_varchar2_table(43) := '68617320616C7265616479206265656E2073686F776E0A202020207661722063757272656E7454696D656F75744964203D20464F532E6D6573736167652E73686F774572726F722E74696D656F757449643B0A202020206966202863757272656E745469';
wwv_flow_api.g_varchar2_table(44) := '6D656F7574496429207B0A2020202020202020636C656172496E74657276616C2863757272656E7454696D656F75744964293B0A202020202020202064656C65746520464F532E6D6573736167652E73686F774572726F722E74696D656F757449643B0A';
wwv_flow_api.g_varchar2_table(45) := '202020207D0A0A202020202F2F206F7074696F6E616C6C7920636C656172206578697374696E67206572726F7273206265666F72652073686F77696E6720746865206E6577206F6E650A2020202069662028636F6E6669672E636C6561724572726F7273';
wwv_flow_api.g_varchar2_table(46) := '2920464F532E6D6573736167652E636C6561724572726F727328293B0A0A202020202F2F206966207765206173736F636961746520746865206D657373616765207769746820616E206974656D207468656E207765206D6179206861766520646566696E';
wwv_flow_api.g_varchar2_table(47) := '6564206D756C7469706C652070616765206974656D730A2020202069662028636F6E6669672E706167654974656D20262620636F6E6669672E6C6F636174696F6E2E696E636C756465732827696E6C696E65272929207B0A20202020202020202F2F2053';
wwv_flow_api.g_varchar2_table(48) := '686F77206F75722070616765206974656D206572726F72730A2020202020202020636F6E6669672E706167654974656D2E73706C697428272C27292E666F72456163682866756E6374696F6E2028706167654974656D29207B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(49) := '20202F2F2053686F77206F75722041504558206572726F72206D6573736167650A202020202020202020202020617065782E6D6573736167652E73686F774572726F7273287B0A20202020202020202020202020202020747970653A20276572726F7227';
wwv_flow_api.g_varchar2_table(50) := '2C0A202020202020202020202020202020206C6F636174696F6E3A205B27696E6C696E65275D2C0A20202020202020202020202020202020706167654974656D3A20706167654974656D2C0A202020202020202020202020202020206D6573736167653A';
wwv_flow_api.g_varchar2_table(51) := '206D6573736167652C0A202020202020202020202020202020202F2F616E79206573636170696E6720697320617373756D656420746F2068617665206265656E20646F6E65206279206E6F770A20202020202020202020202020202020756E736166653A';
wwv_flow_api.g_varchar2_table(52) := '2066616C73650A2020202020202020202020207D293B0A20202020202020207D293B0A20202020202020202F2F2073686F77206172652070616765206C6576656C206572726F7220696620646566696E65640A202020202020202069662028636F6E6669';
wwv_flow_api.g_varchar2_table(53) := '672E6C6F636174696F6E2E696E636C75646573282770616765272929207B0A202020202020202020202020617065782E6D6573736167652E73686F774572726F7273287B0A20202020202020202020202020202020747970653A20276572726F72272C0A';
wwv_flow_api.g_varchar2_table(54) := '202020202020202020202020202020206C6F636174696F6E3A205B2770616765275D2C0A20202020202020202020202020202020706167654974656D3A20756E646566696E65642C0A202020202020202020202020202020206D6573736167653A206D65';
wwv_flow_api.g_varchar2_table(55) := '73736167652C0A202020202020202020202020202020202F2F616E79206573636170696E6720697320617373756D656420746F2068617665206265656E20646F6E65206279206E6F770A20202020202020202020202020202020756E736166653A206661';
wwv_flow_api.g_varchar2_table(56) := '6C73650A2020202020202020202020207D293B0A20202020202020207D0A202020207D20656C7365207B0A20202020202020202F2F2053686F77206F7572206572726F72206D6573736167650A2020202020202020617065782E6D6573736167652E7368';
wwv_flow_api.g_varchar2_table(57) := '6F774572726F7273287B0A202020202020202020202020747970653A20276572726F72272C0A2020202020202020202020206C6F636174696F6E3A20636F6E6669672E6C6F636174696F6E2C0A202020202020202020202020706167654974656D3A2063';
wwv_flow_api.g_varchar2_table(58) := '6F6E6669672E706167654974656D2C0A2020202020202020202020206D6573736167653A206D6573736167652C0A2020202020202020202020202F2F616E79206573636170696E6720697320617373756D656420746F2068617665206265656E20646F6E';
wwv_flow_api.g_varchar2_table(59) := '65206279206E6F770A202020202020202020202020756E736166653A2066616C73650A20202020202020207D293B0A202020207D0A0A202020202F2F207365747570206F75722074696D657220746F206175746F206469736D69737320746865206D6573';
wwv_flow_api.g_varchar2_table(60) := '736167652061667465722058207365636F6E64730A2020202069662028636F6E6669672E6475726174696F6E29207B0A2020202020202020464F532E6D6573736167652E73686F774572726F722E74696D656F75744964203D2073657454696D656F7574';
wwv_flow_api.g_varchar2_table(61) := '2866756E6374696F6E202829207B0A202020202020202020202020464F532E6D6573736167652E636C6561724572726F727328293B0A20202020202020207D2C20636F6E6669672E6475726174696F6E293B0A202020207D0A7D3B0A0A464F532E6D6573';
wwv_flow_api.g_varchar2_table(62) := '736167652E636C6561724572726F7273203D2066756E6374696F6E2028706167654974656D7329207B0A202020202F2F20636865636B2069662077652061726520636C656172696E672031206F72206D6F72652070616765206974656D73206966206E6F';
wwv_flow_api.g_varchar2_table(63) := '74207765207468656E20636C6561722065766572797468696E670A202020206966202841727261792E6973417272617928706167654974656D732920262620706167654974656D732E6C656E677468203E203029207B0A20202020202020207061676549';
wwv_flow_api.g_varchar2_table(64) := '74656D732E666F72456163682866756E6374696F6E20286974656D2C20696E64657829207B0A202020202020202020202020696620286974656D2920617065782E6D6573736167652E636C6561724572726F7273286974656D2E7472696D2829293B0A20';
wwv_flow_api.g_varchar2_table(65) := '202020202020207D290A202020207D20656C7365207B0A2020202020202020617065782E6D6573736167652E636C6561724572726F727328293B0A202020207D0A7D3B0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(106309155453956067)
,p_plugin_id=>wwv_flow_api.id(106296184223956059)
,p_file_name=>'js/script.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '7B2276657273696F6E223A332C22736F7572636573223A5B227363726970742E6A73225D2C226E616D6573223A5B22464F53222C2277696E646F77222C226D657373616765222C22616374696F6E222C226461436F6E74657874222C22636F6E66696722';
wwv_flow_api.g_varchar2_table(2) := '2C22696E6974466E222C2261706578222C226465627567222C22696E666F222C2246756E6374696F6E222C2263616C6C222C22696E6465784F66222C22616374696F6E54797065222C226C6F67222C22706C7567696E4E616D65222C227574696C222C22';
wwv_flow_api.g_varchar2_table(3) := '6170706C7954656D706C617465222C2264656661756C7445736361706546696C746572222C22657363617065222C2265736361706548544D4C222C2273686F775061676553756363657373222C22686964655061676553756363657373222C2273686F77';
wwv_flow_api.g_varchar2_table(4) := '4572726F72222C22636C6561724572726F7273222C22706167654974656D73222C2263757272656E7454696D656F75744964222C2274696D656F75744964222C22636C656172496E74657276616C222C226475726174696F6E222C2273657454696D656F';
wwv_flow_api.g_varchar2_table(5) := '7574222C22706167654974656D222C226C6F636174696F6E222C22696E636C75646573222C2273706C6974222C22666F7245616368222C2273686F774572726F7273222C2274797065222C22756E73616665222C22756E646566696E6564222C22417272';
wwv_flow_api.g_varchar2_table(6) := '6179222C2269734172726179222C226C656E677468222C226974656D222C22696E646578222C227472696D225D2C226D617070696E6773223A22414145412C49414149412C4941414D432C4F41414F442C4B41414F2C4741437842412C49414149452C51';
wwv_flow_api.g_varchar2_table(7) := '414155462C49414149452C534141572C474167423742462C49414149452C51414151432C4F4141532C53414155432C45414157432C45414151432C47414539432C494151494A2C4541474A2C474156414B2C4B41414B432C4D41414D432C4B41444D2C77';
wwv_flow_api.g_varchar2_table(8) := '424143574A2C4741477842432C6141416B42492C5541436C424A2C4541414F4B2C4B41414B502C45414157432C47414D76422C434141432C6B4241416D422C614141614F2C51414151502C4541414F512C614141652C454141472C4341576C452C4B4152';
wwv_flow_api.g_varchar2_table(9) := '49582C45414441472C4541414F482C6D4241416D42512C53414368424C2C4541414F482C51414151532C4B41414B502C4741457042432C4541414F482C5341656A422C594144414B2C4B41414B432C4D41414D4D2C49414149542C4541414F552C574141';
wwv_flow_api.g_varchar2_table(10) := '612C2B4341506E43622C454141554B2C4B41414B532C4B41414B432C63414163662C454141532C434143764367422C6F42414171422C4F41577A42622C4541414F632C534143506A422C454141554B2C4B41414B532C4B41414B492C574141576C422C49';
wwv_flow_api.g_varchar2_table(11) := '414976432C4F414151472C4541414F512C594143582C4941414B2C6B42414344622C49414149452C514141516D422C6742414167426E422C45414153472C4541414F412C51414335432C4D41434A2C4941414B2C6B424143444C2C49414149452C514141';
wwv_flow_api.g_varchar2_table(12) := '516F422C6B4241435A2C4D41434A2C4941414B2C5941434474422C49414149452C5141415171422C5541415572422C45414153472C4541414F412C51414374432C4D41434A2C4941414B2C634143444C2C49414149452C5141415173422C594141596E42';
wwv_flow_api.g_varchar2_table(13) := '2C4541414F6F422C61414B33437A422C49414149452C514141516D422C674241416B422C534141556E422C45414153472C47414737432C4941414971422C4541416D4231422C49414149452C514141516D422C6742414167424D2C5541432F43442C4941';
wwv_flow_api.g_varchar2_table(14) := '4341452C63414163462C5541435031422C49414149452C514141516D422C6742414167424D2C574149764370422C4B41414B4C2C514141516D422C6742414167426E422C4741477A42472C4541414F77422C5741435037422C49414149452C514141516D';
wwv_flow_api.g_varchar2_table(15) := '422C6742414167424D2C55414159472C594141572C5741432F4339422C49414149452C514141516F422C6F424143626A422C4541414F77422C5941496C4237422C49414149452C514141516F422C674241416B422C5741433142662C4B41414B4C2C5141';
wwv_flow_api.g_varchar2_table(16) := '41516F422C6D4241476A4274422C49414149452C5141415171422C554141592C5341415572422C45414153472C47414776432C4941414971422C4541416D4231422C49414149452C5141415171422C55414155492C5541437A43442C49414341452C6341';
wwv_flow_api.g_varchar2_table(17) := '4163462C5541435031422C49414149452C5141415171422C55414155492C574149374274422C4541414F6D422C6141416178422C49414149452C5141415173422C63414768436E422C4541414F30422C5541415931422C4541414F32422C53414153432C';
wwv_flow_api.g_varchar2_table(18) := '534141532C574145354335422C4541414F30422C53414153472C4D41414D2C4B41414B432C534141512C534141554A2C4741457A4378422C4B41414B4C2C514141516B432C574141572C4341437042432C4B41414D2C5141434E4C2C534141552C434141';
wwv_flow_api.g_varchar2_table(19) := '432C55414358442C53414155412C4541435637422C51414153412C454145546F432C514141512C4F41495A6A432C4541414F32422C53414153432C534141532C5341437A4231422C4B41414B4C2C514141516B432C574141572C4341437042432C4B4141';
wwv_flow_api.g_varchar2_table(20) := '4D2C5141434E4C2C534141552C434141432C51414358442C63414155512C4541435672432C51414153412C454145546F432C514141512C4B414B68422F422C4B41414B4C2C514141516B432C574141572C4341437042432C4B41414D2C5141434E4C2C53';
wwv_flow_api.g_varchar2_table(21) := '41415533422C4541414F32422C5341436A42442C5341415531422C4541414F30422C5341436A4237422C51414153412C454145546F432C514141512C49414B5A6A432C4541414F77422C5741435037422C49414149452C5141415171422C55414155492C';
wwv_flow_api.g_varchar2_table(22) := '55414159472C594141572C5741437A4339422C49414149452C5141415173422C67424143626E422C4541414F77422C5941496C4237422C49414149452C5141415173422C594141632C53414155432C4741453542652C4D41414D432C5141415168422C49';
wwv_flow_api.g_varchar2_table(23) := '414163412C4541415569422C4F4141532C4541432F436A422C45414155552C534141512C53414155512C4541414D432C4741433142442C4741414D70432C4B41414B4C2C5141415173422C594141596D422C4541414B452C574147354374432C4B41414B';
wwv_flow_api.g_varchar2_table(24) := '4C2C514141517342222C2266696C65223A227363726970742E6A73227D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(106309595409956067)
,p_plugin_id=>wwv_flow_api.id(106296184223956059)
,p_file_name=>'js/script.js.map'
,p_mime_type=>'application/json'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '76617220464F533D77696E646F772E464F537C7C7B7D3B464F532E6D6573736167653D464F532E6D6573736167657C7C7B7D2C464F532E6D6573736167652E616374696F6E3D66756E6374696F6E28652C732C61297B76617220723B696628617065782E';
wwv_flow_api.g_varchar2_table(2) := '64656275672E696E666F2822464F53202D204D65737361676520416374696F6E73222C73292C6120696E7374616E63656F662046756E6374696F6E2626612E63616C6C28652C73292C5B2273686F775061676553756363657373222C2273686F77457272';
wwv_flow_api.g_varchar2_table(3) := '6F72225D2E696E6465784F6628732E616374696F6E54797065293E2D31297B6966282128723D732E6D65737361676520696E7374616E63656F662046756E6374696F6E3F732E6D6573736167652E63616C6C2865293A732E6D6573736167652929726574';
wwv_flow_api.g_varchar2_table(4) := '75726E20766F696420617065782E64656275672E6C6F6728732E706C7567696E4E616D652B223A20746865206D65737361676520697320656D7074792C20736F206974206973206E6F742073686F776E2122293B723D617065782E7574696C2E6170706C';
wwv_flow_api.g_varchar2_table(5) := '7954656D706C61746528722C7B64656661756C7445736361706546696C7465723A6E756C6C7D292C732E657363617065262628723D617065782E7574696C2E65736361706548544D4C287229297D73776974636828732E616374696F6E54797065297B63';
wwv_flow_api.g_varchar2_table(6) := '6173652273686F775061676553756363657373223A464F532E6D6573736167652E73686F77506167655375636365737328722C732E636F6E666967293B627265616B3B6361736522686964655061676553756363657373223A464F532E6D657373616765';
wwv_flow_api.g_varchar2_table(7) := '2E68696465506167655375636365737328293B627265616B3B636173652273686F774572726F72223A464F532E6D6573736167652E73686F774572726F7228722C732E636F6E666967293B627265616B3B6361736522636C6561724572726F7273223A46';
wwv_flow_api.g_varchar2_table(8) := '4F532E6D6573736167652E636C6561724572726F727328732E706167654974656D73297D7D2C464F532E6D6573736167652E73686F7750616765537563636573733D66756E6374696F6E28652C73297B76617220613D464F532E6D6573736167652E7368';
wwv_flow_api.g_varchar2_table(9) := '6F7750616765537563636573732E74696D656F757449643B61262628636C656172496E74657276616C2861292C64656C65746520464F532E6D6573736167652E73686F7750616765537563636573732E74696D656F75744964292C617065782E6D657373';
wwv_flow_api.g_varchar2_table(10) := '6167652E73686F7750616765537563636573732865292C732E6475726174696F6E262628464F532E6D6573736167652E73686F7750616765537563636573732E74696D656F757449643D73657454696D656F7574282866756E6374696F6E28297B464F53';
wwv_flow_api.g_varchar2_table(11) := '2E6D6573736167652E68696465506167655375636365737328297D292C732E6475726174696F6E29297D2C464F532E6D6573736167652E6869646550616765537563636573733D66756E6374696F6E28297B617065782E6D6573736167652E6869646550';
wwv_flow_api.g_varchar2_table(12) := '6167655375636365737328297D2C464F532E6D6573736167652E73686F774572726F723D66756E6374696F6E28652C73297B76617220613D464F532E6D6573736167652E73686F774572726F722E74696D656F757449643B61262628636C656172496E74';
wwv_flow_api.g_varchar2_table(13) := '657276616C2861292C64656C65746520464F532E6D6573736167652E73686F774572726F722E74696D656F75744964292C732E636C6561724572726F72732626464F532E6D6573736167652E636C6561724572726F727328292C732E706167654974656D';
wwv_flow_api.g_varchar2_table(14) := '2626732E6C6F636174696F6E2E696E636C756465732822696E6C696E6522293F28732E706167654974656D2E73706C697428222C22292E666F7245616368282866756E6374696F6E2873297B617065782E6D6573736167652E73686F774572726F727328';
wwv_flow_api.g_varchar2_table(15) := '7B747970653A226572726F72222C6C6F636174696F6E3A5B22696E6C696E65225D2C706167654974656D3A732C6D6573736167653A652C756E736166653A21317D297D29292C732E6C6F636174696F6E2E696E636C756465732822706167652229262661';
wwv_flow_api.g_varchar2_table(16) := '7065782E6D6573736167652E73686F774572726F7273287B747970653A226572726F72222C6C6F636174696F6E3A5B2270616765225D2C706167654974656D3A766F696420302C6D6573736167653A652C756E736166653A21317D29293A617065782E6D';
wwv_flow_api.g_varchar2_table(17) := '6573736167652E73686F774572726F7273287B747970653A226572726F72222C6C6F636174696F6E3A732E6C6F636174696F6E2C706167654974656D3A732E706167654974656D2C6D6573736167653A652C756E736166653A21317D292C732E64757261';
wwv_flow_api.g_varchar2_table(18) := '74696F6E262628464F532E6D6573736167652E73686F774572726F722E74696D656F757449643D73657454696D656F7574282866756E6374696F6E28297B464F532E6D6573736167652E636C6561724572726F727328297D292C732E6475726174696F6E';
wwv_flow_api.g_varchar2_table(19) := '29297D2C464F532E6D6573736167652E636C6561724572726F72733D66756E6374696F6E2865297B41727261792E697341727261792865292626652E6C656E6774683E303F652E666F7245616368282866756E6374696F6E28652C73297B652626617065';
wwv_flow_api.g_varchar2_table(20) := '782E6D6573736167652E636C6561724572726F727328652E7472696D2829297D29293A617065782E6D6573736167652E636C6561724572726F727328297D3B0A2F2F2320736F757263654D617070696E6755524C3D7363726970742E6A732E6D6170';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(106309973288956067)
,p_plugin_id=>wwv_flow_api.id(106296184223956059)
,p_file_name=>'js/script.min.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done


