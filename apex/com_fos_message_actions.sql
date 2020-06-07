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

prompt APPLICATION 102 - FOS Dev
--
-- Application Export:
--   Application:     102
--   Name:            FOS Dev
--   Exported By:     FOS_MASTER_WS
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 37441962356114799
--     PLUGIN: 1846579882179407086
--     PLUGIN: 8354320589762683
--     PLUGIN: 50031193176975232
--     PLUGIN: 34175298479606152
--     PLUGIN: 2657630155025963
--     PLUGIN: 35822631205839510
--     PLUGIN: 14934236679644451
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
 p_id=>wwv_flow_api.id(34175298479606152)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'COM.FOS.MESSAGE_ACTIONS'
,p_display_name=>'FOS - Message Actions'
,p_category=>'EXECUTE'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_javascript_file_urls=>'#PLUGIN_FILES#js/script.min.js'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function render',
'    ( p_dynamic_action apex_plugin.t_dynamic_action',
'    , p_plugin         apex_plugin.t_plugin',
'    )',
'return apex_plugin.t_dynamic_action_render_result',
'as',
'    l_result apex_plugin.t_dynamic_action_render_result;',
'',
'    --general attributes',
'    l_action       p_dynamic_action.attribute_01%type := p_dynamic_action.attribute_01;',
'    l_message_type p_dynamic_action.attribute_02%type := p_dynamic_action.attribute_02;',
'    l_message      p_dynamic_action.attribute_03%type := p_dynamic_action.attribute_03;',
'    l_js_code      p_dynamic_action.attribute_04%type := p_dynamic_action.attribute_04;',
'    l_escape       boolean                            := p_dynamic_action.attribute_05 = ''Y'';',
'',
'    -- error configuration',
'    l_err_display_location apex_t_varchar2 := apex_string.split(p_dynamic_action.attribute_06, '':'');',
'    l_err_associated_item  p_dynamic_action.attribute_07%type := p_dynamic_action.attribute_07;',
'    ',
'    -- success configuration',
'    l_autodismiss boolean                            := p_dynamic_action.attribute_08 = ''Y'';',
'    l_duration    p_dynamic_action.attribute_09%type := p_dynamic_action.attribute_09;',
'',
'begin',
'',
'    if apex_application.g_debug then',
'        apex_plugin_util.debug_dynamic_action',
'            ( p_dynamic_action => p_dynamic_action',
'            , p_plugin         => p_plugin',
'            );',
'    end if;',
'',
'    apex_json.initialize_clob_output;',
'    apex_json.open_object;',
'    ',
'    if l_action in (''show-page-success'', ''show-error'') then',
'        if l_message_type =  ''static'' then',
'            apex_json.write(''message'', l_message);',
'        else',
'            apex_json.write_raw',
'                ( p_name  => ''message''',
'                , p_value => case l_message_type',
'                     when ''javascript-expression'' then',
'                        ''function(){return ('' || l_js_code || '');}''',
'                     when ''javascript-function-body'' then',
'                         ''function(){'' || l_js_code || ''}''',
'                     end',
'                );',
'        end if;',
'    end if;',
'    ',
'    case l_action',
'        when ''show-page-success'' then',
'            apex_json.write(''actionType'', ''showPageSuccess'');',
'            apex_json.write(''escape''    , l_escape);',
'',
'            apex_json.open_object(''config'');',
'            apex_json.write(''duration'', l_duration);',
'            apex_json.close_object;',
'        ',
'        when ''hide-page-success'' then',
'            apex_json.write(''actionType'', ''hidePageSuccess'');',
'',
'        when ''show-error'' then',
'            apex_json.write(''actionType'', ''showError'');    ',
'            apex_json.write(''escape''    , l_escape);',
'',
'            apex_json.open_object(''config'');',
'            apex_json.write(''location'', l_err_display_location);',
'            apex_json.write(''pageItem'', l_err_associated_item);',
'            apex_json.close_object;',
'        ',
'        when ''clear-errors'' then',
'            apex_json.write(''actionType'', ''clearErrors'');',
'            ',
'    end case;',
'',
'    apex_json.close_object;',
'',
'    l_result.javascript_function := ''function(){FOS.message.action(this, '' || apex_json.get_clob_output || '');}'';',
'',
'    apex_json.free_output;',
'    return l_result;',
'end;'))
,p_api_version=>2
,p_render_function=>'render'
,p_substitute_attributes=>false
,p_subscribe_plugin_settings=>true
,p_help_text=>'<p>A set of actions which handle client-side display and management of messages such as success and error notifications.</p>'
,p_version_identifier=>'20.1.0'
,p_about_url=>'https://fos.world'
,p_plugin_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Settings for the FOS browser extension',
'@fos-auto-return-to-page',
'@fos-auto-open-files:js/script.js',
'',
'// Export',
'@fos-export',
'',
'// Attributes for the apexplugin.json file',
'@fos-keywords:notification,success,error',
'@fos-github-slug:fos-message-actions',
'@fos-demo-page-id:1030'))
,p_files_version=>93
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(34188684109629343)
,p_plugin_id=>wwv_flow_api.id(34175298479606152)
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
 p_id=>wwv_flow_api.id(34189065996632619)
,p_plugin_attribute_id=>wwv_flow_api.id(34188684109629343)
,p_display_sequence=>10
,p_display_value=>'Show Page Success'
,p_return_value=>'show-page-success'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Displays a success notification.</p>',
'<p>Note that if one already exists, it will be replaced.</p>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(34190401900882597)
,p_plugin_attribute_id=>wwv_flow_api.id(34188684109629343)
,p_display_sequence=>20
,p_display_value=>'Hide Page Success'
,p_return_value=>'hide-page-success'
,p_help_text=>'<p>Hides the success notification if one is present.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(34189439983634060)
,p_plugin_attribute_id=>wwv_flow_api.id(34188684109629343)
,p_display_sequence=>30
,p_display_value=>'Show Error'
,p_return_value=>'show-error'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Displays an error notification.</p>',
'<p>It can be displayed on page, targeted to a specific item, or both.</p>',
'<p>By default, error notifications are added to a stack, which means you can call this action multiple times to display various errors. If you wish to clear the stack and only display this error, make sure to call the "Clear Errors" action first.</p>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(34190814319884176)
,p_plugin_attribute_id=>wwv_flow_api.id(34188684109629343)
,p_display_sequence=>40
,p_display_value=>'Clear Errors'
,p_return_value=>'clear-errors'
,p_help_text=>'<p>Clears all current error notifications.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(8683261729132706)
,p_plugin_id=>wwv_flow_api.id(34175298479606152)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Message Type'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'static'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(34188684109629343)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'show-page-success,show-error'
,p_lov_type=>'STATIC'
,p_help_text=>'<p>The source type of the message to be displayed.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(8683590172134177)
,p_plugin_attribute_id=>wwv_flow_api.id(8683261729132706)
,p_display_sequence=>10
,p_display_value=>'Static Text'
,p_return_value=>'static'
,p_help_text=>'<p>A static value</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(8683966916135697)
,p_plugin_attribute_id=>wwv_flow_api.id(8683261729132706)
,p_display_sequence=>20
,p_display_value=>'JavaScript Expression'
,p_return_value=>'javascript-expression'
,p_help_text=>'<p>A JavaScript Expression</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(8684352297137054)
,p_plugin_attribute_id=>wwv_flow_api.id(8683261729132706)
,p_display_sequence=>30
,p_display_value=>'JavaScript Function Body'
,p_return_value=>'javascript-function-body'
,p_help_text=>'<p>A JavaScript function body returning a string</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(34191187138897099)
,p_plugin_id=>wwv_flow_api.id(34175298479606152)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Message'
,p_attribute_type=>'TEXTAREA'
,p_is_required=>true
,p_is_translatable=>true
,p_depending_on_attribute_id=>wwv_flow_api.id(8683261729132706)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'static'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>The message to be displayed.</p>',
'<p>You can reference any page item by using the "&PAGE_ITEM." format. To escape the page item value, either set "Escape Special Characters" to "Yes", use "&PAGE_ITEM!HTML." the subsitution format.</p>',
'<p><b>Note: </b> The substitution will be done in the browser, with the current page item values.</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(8705594689552831)
,p_plugin_id=>wwv_flow_api.id(34175298479606152)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'JavaScript Code'
,p_attribute_type=>'JAVASCRIPT'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(8683261729132706)
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
,p_help_text=>'<p>The JavaScript Code resulting in a message string.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(34446527436676893)
,p_plugin_id=>wwv_flow_api.id(34175298479606152)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Escape Special Characters'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(34188684109629343)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'show-page-success,show-error'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>To prevent Cross-Site Scripting (XSS) attacks, always set this attribute to "Yes". If you need to render HTML tags in the message, set this attribute to "No".</p>',
'<p><b>Note:</b> You can still escape only certain page items, by using the &PAGE_ITEM!HTML. substitution string format.</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(34194515087791982)
,p_plugin_id=>wwv_flow_api.id(34175298479606152)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Display Location'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'inline:page'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(34188684109629343)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'SHOW_ERROR'
,p_lov_type=>'STATIC'
,p_help_text=>'<p>Select where the error message is displayed. Error messages can be displayed inline underneath an Associated Item label and/or in a Notification area, defined as part of the page template.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(8634976976643718)
,p_plugin_attribute_id=>wwv_flow_api.id(34194515087791982)
,p_display_sequence=>10
,p_display_value=>'Inline with Field and in Notification'
,p_return_value=>'inline:page'
,p_help_text=>'<p>Both inline with a specific Page Item and in a notification</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(8635376219645600)
,p_plugin_attribute_id=>wwv_flow_api.id(34194515087791982)
,p_display_sequence=>20
,p_display_value=>'Inline with Field'
,p_return_value=>'inline'
,p_help_text=>'<p>Inline with a specific Page Item</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(8635718093647531)
,p_plugin_attribute_id=>wwv_flow_api.id(34194515087791982)
,p_display_sequence=>30
,p_display_value=>'Inline in Notification'
,p_return_value=>'page'
,p_help_text=>'<p>In a notification</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(34194780932794713)
,p_plugin_id=>wwv_flow_api.id(34175298479606152)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Associated Item'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(34194515087791982)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'inline,inline:page'
,p_help_text=>'<p>Displays the error notification inline with a page item.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(34290499320273340)
,p_plugin_id=>wwv_flow_api.id(34175298479606152)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'Autodismiss'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(34188684109629343)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'show-page-success'
,p_help_text=>'<p>By default, success notifications are displayed until the user closes them. Set this attribute to "Yes" to auto dismiss the notification after a specific amount of time.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(34322323847767145)
,p_plugin_id=>wwv_flow_api.id(34175298479606152)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'Duration'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'3000'
,p_unit=>'milliseconds'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(34290499320273340)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>'<p>The time in milliseconds until the success notification will be dismissed.</p>'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '77696E646F772E464F5309092020203D2077696E646F772E464F530909097C7C207B7D3B0A77696E646F772E464F532E6D657373616765203D2077696E646F772E464F532E6D657373616765207C7C207B7D3B0A0A464F532E6D6573736167652E616374';
wwv_flow_api.g_varchar2_table(2) := '696F6E203D2066756E6374696F6E286461436F6E746578742C20636F6E666967297B0A0A20202020617065782E64656275672E696E666F2827464F53202D204D65737361676520416374696F6E73272C20636F6E666967293B0A0A09766172206D657373';
wwv_flow_api.g_varchar2_table(3) := '6167653B0A0A202020202F2F205265706C6163696E6720737562737469747574696E6720737472696E677320616E64206573636170696E6720746865206D6573736167650A202020206966285B2773686F775061676553756363657373272C202773686F';
wwv_flow_api.g_varchar2_table(4) := '774572726F72275D2E696E6465784F6628636F6E6669672E616374696F6E5479706529203E202D31297B0A0A2020202020202020696628636F6E6669672E6D65737361676520696E7374616E63656F662046756E6374696F6E297B0A2020202020202020';
wwv_flow_api.g_varchar2_table(5) := '202020206D657373616765203D20636F6E6669672E6D6573736167652E63616C6C286461436F6E74657874293B0A20202020202020207D20656C7365207B0A2020202020202020202020206D657373616765203D20636F6E6669672E6D6573736167653B';
wwv_flow_api.g_varchar2_table(6) := '0A20202020202020207D0A0A20202020202020202F2F20496E206361736520746865206D65737361676520697320656D7074792C207765206174206C65617374207072696E74206F757420616E20656D7074792073706163650A20202020202020202F2F';
wwv_flow_api.g_varchar2_table(7) := '204F7468657277697365204150455820776F756C642073686F772023535543434553535F4D455353414745230A20202020202020202F2F206170706C7954656D706C61746520616E642065736361706548544D4C20616C736F207468726F77206572726F';
wwv_flow_api.g_varchar2_table(8) := '7273206966206E6F2076616C75652069732070726F76696465640A20202020202020206966286D657373616765203D3D3D202727207C7C206D657373616765203D3D3D206E756C6C207C7C206D657373616765203D3D3D20756E646566696E6564297B0A';
wwv_flow_api.g_varchar2_table(9) := '2020202020202020202020206D657373616765203D202720273B0A20202020202020207D0A20202020202020200A20202020202020202F2F20205265706C6163696E6720737562737469747574696F6E20737472696E67730A20202020202020202F2F20';
wwv_flow_api.g_varchar2_table(10) := '20576520646F6E27742065736361706520746865206D6573736167652062792064656661756C742E205765206C65742074686520646576656C6F70657220646563696465207768657468657220746F206573636170650A20202020202020202F2F202020';
wwv_flow_api.g_varchar2_table(11) := '2020207468652077686F6C65206D6573736167652C206F72206A75737420696E76696475616C2070616765206974656D73207669612024504147455F4954454D2148544D4C2E0A20202020202020206D657373616765203D20617065782E7574696C2E61';
wwv_flow_api.g_varchar2_table(12) := '70706C7954656D706C617465286D6573736167652C207B0A20202020202020202020202064656661756C7445736361706546696C7465723A206E756C6C0A20202020202020207D293B0A0A20202020202020202F2F20457363617065205370656369616C';
wwv_flow_api.g_varchar2_table(13) := '2043686172616374657273206174747269627574650A2020202020202020696628636F6E6669672E657363617065297B0A2020202020202020202020206D657373616765203D20617065782E7574696C2E65736361706548544D4C286D65737361676529';
wwv_flow_api.g_varchar2_table(14) := '3B0A20202020202020207D0A202020207D0A0A0973776974636828636F6E6669672E616374696F6E5479706529207B0A090963617365202773686F775061676553756363657373273A0A090909464F532E6D6573736167652E73686F7750616765537563';
wwv_flow_api.g_varchar2_table(15) := '63657373286D6573736167652C20636F6E6669672E636F6E666967293B0A090909627265616B3B0A0909636173652027686964655061676553756363657373273A0A090909464F532E6D6573736167652E68696465506167655375636365737328293B0A';
wwv_flow_api.g_varchar2_table(16) := '090909627265616B3B0A090963617365202773686F774572726F72273A0A090909464F532E6D6573736167652E73686F774572726F72286D6573736167652C20636F6E6669672E636F6E666967293B0A090909627265616B3B0A0909636173652027636C';
wwv_flow_api.g_varchar2_table(17) := '6561724572726F7273273A0A090909464F532E6D6573736167652E636C6561724572726F727328293B0A090909627265616B3B0A090964656661756C743A0A090909627265616B3B0A097D0A7D3B0A0A464F532E6D6573736167652E73686F7750616765';
wwv_flow_api.g_varchar2_table(18) := '53756363657373203D2066756E6374696F6E286D6573736167652C20636F6E666967297B0A0A202020207661722063757272656E7454696D656F75744964203D20464F532E6D6573736167652E73686F7750616765537563636573732E74696D656F7574';
wwv_flow_api.g_varchar2_table(19) := '49643B0A2020202069662863757272656E7454696D656F75744964297B0A2020202020202020636C656172496E74657276616C2863757272656E7454696D656F75744964293B0A2020202020202020464F532E6D6573736167652E73686F775061676553';
wwv_flow_api.g_varchar2_table(20) := '7563636573732E74696D656F75744964203D20756E646566696E65643B0A202020207D0A0A202020202F2F616E79206573636170696E6720697320617373756D656420746F2068617665206265656E20646F6E65206279206E6F770A2020202061706578';
wwv_flow_api.g_varchar2_table(21) := '2E6D6573736167652E73686F775061676553756363657373286D657373616765293B0A0A20202020696628636F6E6669672E6475726174696F6E297B0A2020202020202020464F532E6D6573736167652E73686F7750616765537563636573732E74696D';
wwv_flow_api.g_varchar2_table(22) := '656F75744964203D2073657454696D656F75742866756E6374696F6E28297B0A202020202020202020202020464F532E6D6573736167652E68696465506167655375636365737328293B0A20202020202020207D2C20636F6E6669672E6475726174696F';
wwv_flow_api.g_varchar2_table(23) := '6E293B0A202020207D0A7D0A0A464F532E6D6573736167652E686964655061676553756363657373203D2066756E6374696F6E28297B0A09617065782E6D6573736167652E68696465506167655375636365737328293B0A7D0A0A464F532E6D65737361';
wwv_flow_api.g_varchar2_table(24) := '67652E73686F774572726F72203D2066756E6374696F6E286D6573736167652C20636F6E666967297B0A09617065782E6D6573736167652E73686F774572726F7273287B0A2020202020202020747970653A20276572726F72272C0A2020202020202020';
wwv_flow_api.g_varchar2_table(25) := '6C6F636174696F6E3A20636F6E6669672E6C6F636174696F6E2C0A2020202020202020706167654974656D3A20636F6E6669672E706167654974656D2C0A20202020202020206D6573736167653A206D6573736167652C0A20202020202020202F2F616E';
wwv_flow_api.g_varchar2_table(26) := '79206573636170696E6720697320617373756D656420746F2068617665206265656E20646F6E65206279206E6F770A2020202020202020756E736166653A2066616C73650A097D293B0A7D0A0A464F532E6D6573736167652E636C6561724572726F7273';
wwv_flow_api.g_varchar2_table(27) := '203D2066756E6374696F6E28297B0A09617065782E6D6573736167652E636C6561724572726F727328293B0A7D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(34185023327606255)
,p_plugin_id=>wwv_flow_api.id(34175298479606152)
,p_file_name=>'js/script.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '7B2276657273696F6E223A332C22736F7572636573223A5B227363726970742E6A73225D2C226E616D6573223A5B2277696E646F77222C22464F53222C226D657373616765222C22616374696F6E222C226461436F6E74657874222C22636F6E66696722';
wwv_flow_api.g_varchar2_table(2) := '2C2261706578222C226465627567222C22696E666F222C22696E6465784F66222C22616374696F6E54797065222C2246756E6374696F6E222C2263616C6C222C227574696C222C226170706C7954656D706C617465222C2264656661756C744573636170';
wwv_flow_api.g_varchar2_table(3) := '6546696C746572222C22657363617065222C2265736361706548544D4C222C2273686F775061676553756363657373222C22686964655061676553756363657373222C2273686F774572726F72222C22636C6561724572726F7273222C2263757272656E';
wwv_flow_api.g_varchar2_table(4) := '7454696D656F75744964222C2274696D656F75744964222C22636C656172496E74657276616C222C22756E646566696E6564222C226475726174696F6E222C2273657454696D656F7574222C2273686F774572726F7273222C2274797065222C226C6F63';
wwv_flow_api.g_varchar2_table(5) := '6174696F6E222C22706167654974656D222C22756E73616665225D2C226D617070696E6773223A2241414141412C4F41414F432C49414155442C4F41414F432C4B4141532C4741436A43442C4F41414F432C49414149432C51414155462C4F41414F432C';
wwv_flow_api.g_varchar2_table(6) := '49414149432C534141572C4741453343442C49414149432C51414151432C4F4141532C53414153432C45414157432C47414978432C49414149482C45412B424A2C4F416A4347492C4B41414B432C4D41414D432C4B41414B2C774241417942482C47414B';
wwv_flow_api.g_varchar2_table(7) := '74432C434141432C6B4241416D422C61414161492C514141514A2C4541414F4B2C614141652C4941572F432C4D415258522C45414444472C4541414F482C6D4241416D42532C534143664E2C4541414F482C51414151552C4B41414B522C474145704243';
wwv_flow_api.g_varchar2_table(8) := '2C4541414F482C55414D6C42412C4D41416B42412C4941436A42412C454141552C4B414D64412C45414155492C4B41414B4F2C4B41414B432C634141635A2C454141532C4341437643612C6F42414171422C4F41497442562C4541414F572C5341434E64';
wwv_flow_api.g_varchar2_table(9) := '2C45414155492C4B41414B4F2C4B41414B492C57414157662C4B41496E43472C4541414F4B2C594143622C4941414B2C6B4241434A542C49414149432C5141415167422C67424141674268422C45414153472C4541414F412C51414335432C4D4143442C';
wwv_flow_api.g_varchar2_table(10) := '4941414B2C6B4241434A4A2C49414149432C5141415169422C6B4241435A2C4D4143442C4941414B2C5941434A6C422C49414149432C514141516B422C554141556C422C45414153472C4541414F412C51414374432C4D4143442C4941414B2C6341434A';
wwv_flow_api.g_varchar2_table(11) := '4A2C49414149432C514141516D422C6742414F6670422C49414149432C5141415167422C674241416B422C5341415368422C45414153472C47414535432C4941414969422C4541416D4272422C49414149432C5141415167422C6742414167424B2C5541';
wwv_flow_api.g_varchar2_table(12) := '436844442C49414343452C63414163462C4741436472422C49414149432C5141415167422C6742414167424B2C65414159452C47414935436E422C4B41414B4A2C5141415167422C67424141674268422C4741453142472C4541414F71422C5741434E7A';
wwv_flow_api.g_varchar2_table(13) := '422C49414149432C5141415167422C6742414167424B2C55414159492C594141572C5741432F4331422C49414149432C5141415169422C6F42414362642C4541414F71422C5941496C427A422C49414149432C5141415169422C674241416B422C574143';
wwv_flow_api.g_varchar2_table(14) := '3742622C4B41414B4A2C5141415169422C6D424147646C422C49414149432C514141516B422C554141592C534141536C422C45414153472C4741437A43432C4B41414B4A2C5141415130422C574141572C4341436A42432C4B41414D2C5141434E432C53';
wwv_flow_api.g_varchar2_table(15) := '4141557A422C4541414F79422C5341436A42432C5341415531422C4541414F30422C5341436A4237422C51414153412C4541455438422C514141512C4B414968422F422C49414149432C514141516D422C594141632C5741437A42662C4B41414B4A2C51';
wwv_flow_api.g_varchar2_table(16) := '4141516D42222C2266696C65223A227363726970742E6A73227D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(34185373259606257)
,p_plugin_id=>wwv_flow_api.id(34175298479606152)
,p_file_name=>'js/script.js.map'
,p_mime_type=>'application/json'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '77696E646F772E464F533D77696E646F772E464F537C7C7B7D2C77696E646F772E464F532E6D6573736167653D77696E646F772E464F532E6D6573736167657C7C7B7D2C464F532E6D6573736167652E616374696F6E3D66756E6374696F6E28652C7329';
wwv_flow_api.g_varchar2_table(2) := '7B76617220613B73776974636828617065782E64656275672E696E666F2822464F53202D204D65737361676520416374696F6E73222C73292C5B2273686F775061676553756363657373222C2273686F774572726F72225D2E696E6465784F6628732E61';
wwv_flow_api.g_varchar2_table(3) := '6374696F6E54797065293E2D312626282222213D3D28613D732E6D65737361676520696E7374616E63656F662046756E6374696F6E3F732E6D6573736167652E63616C6C2865293A732E6D6573736167652926266E756C6C213D617C7C28613D22202229';
wwv_flow_api.g_varchar2_table(4) := '2C613D617065782E7574696C2E6170706C7954656D706C61746528612C7B64656661756C7445736361706546696C7465723A6E756C6C7D292C732E657363617065262628613D617065782E7574696C2E65736361706548544D4C28612929292C732E6163';
wwv_flow_api.g_varchar2_table(5) := '74696F6E54797065297B636173652273686F775061676553756363657373223A464F532E6D6573736167652E73686F77506167655375636365737328612C732E636F6E666967293B627265616B3B6361736522686964655061676553756363657373223A';
wwv_flow_api.g_varchar2_table(6) := '464F532E6D6573736167652E68696465506167655375636365737328293B627265616B3B636173652273686F774572726F72223A464F532E6D6573736167652E73686F774572726F7228612C732E636F6E666967293B627265616B3B6361736522636C65';
wwv_flow_api.g_varchar2_table(7) := '61724572726F7273223A464F532E6D6573736167652E636C6561724572726F727328297D7D2C464F532E6D6573736167652E73686F7750616765537563636573733D66756E6374696F6E28652C73297B76617220613D464F532E6D6573736167652E7368';
wwv_flow_api.g_varchar2_table(8) := '6F7750616765537563636573732E74696D656F757449643B61262628636C656172496E74657276616C2861292C464F532E6D6573736167652E73686F7750616765537563636573732E74696D656F757449643D766F69642030292C617065782E6D657373';
wwv_flow_api.g_varchar2_table(9) := '6167652E73686F7750616765537563636573732865292C732E6475726174696F6E262628464F532E6D6573736167652E73686F7750616765537563636573732E74696D656F757449643D73657454696D656F7574282866756E6374696F6E28297B464F53';
wwv_flow_api.g_varchar2_table(10) := '2E6D6573736167652E68696465506167655375636365737328297D292C732E6475726174696F6E29297D2C464F532E6D6573736167652E6869646550616765537563636573733D66756E6374696F6E28297B617065782E6D6573736167652E6869646550';
wwv_flow_api.g_varchar2_table(11) := '6167655375636365737328297D2C464F532E6D6573736167652E73686F774572726F723D66756E6374696F6E28652C73297B617065782E6D6573736167652E73686F774572726F7273287B747970653A226572726F72222C6C6F636174696F6E3A732E6C';
wwv_flow_api.g_varchar2_table(12) := '6F636174696F6E2C706167654974656D3A732E706167654974656D2C6D6573736167653A652C756E736166653A21317D297D2C464F532E6D6573736167652E636C6561724572726F72733D66756E6374696F6E28297B617065782E6D6573736167652E63';
wwv_flow_api.g_varchar2_table(13) := '6C6561724572726F727328297D3B0A2F2F2320736F757263654D617070696E6755524C3D7363726970742E6A732E6D6170';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(34185839121606257)
,p_plugin_id=>wwv_flow_api.id(34175298479606152)
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


