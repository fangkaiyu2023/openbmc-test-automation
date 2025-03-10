*** Settings ***

Documentation  Test OpenBMC GUI "Server power operations" sub-menu of "Operations".

Resource        ../../lib/gui_resource.robot
Resource        ../../../lib/state_manager.robot

Test Setup      Run Keywords  Launch Browser And Login GUI  AND  Navigate to Server Power Operation Page
Test Teardown   Close Browser


*** Variables ***

${xpath_server_power_heading}              //h1[text()="Server power operations"]
${xpath_enable_onetime_boot_checkbox}      //*[contains(@class,'custom-checkbox')]
${xpath_boot_option_select}                //*[@id='boot-option']
${xpath_shutdown_button}                   //*[@data-test-id='serverPowerOperations-button-shutDown']
${xpath_reboot_button}                     //*[@data-test-id='serverPowerOperations-button-reboot']
${xpath_poweron_button}                    //*[@data-test-id='serverPowerOperations-button-powerOn']
${xpath_save_button}                       //button[contains(text(),'Save')]
${xpath_shutdown_orderly_radio}            //*[@data-test-id='serverPowerOperations-radio-shutdownOrderly']
${xpath_shutdown_immediate_radio}          //*[@data-test-id='serverPowerOperations-radio-shutdownImmediate']
${xpath_confirm_button}                    //button[contains(text(),'Confirm')]
${xpath_current_power_state}               //*[@data-test-id='powerServerOps-text-hostStatus']
${xpath_reboot_immediate_radio}            //*[@data-test-id='serverPowerOperations-radio-rebootImmediate']


*** Test Cases ***

Verify Navigation To Server Power Operations Page
    [Documentation]  Verify navigation to server power operations page.
    [Tags]  Verify_Navigation_To_Server_Power_Operations_Page

    Page Should Contain Element  ${xpath_server_power_heading}


Verify Immediate Shutdown
    [Documentation]  Verify shutdown after clicking immediate shutdown button.
    [Tags]  Verify_Immediate_Shutdown
    [Setup]  Run Keywords  Redfish Power On  stack_mode=skip  AND  Launch Browser And Login GUI
    ...  AND  Navigate to Server Power Operation Page

    Click Element At Coordinates  ${xpath_shutdown_immediate_radio}  0  0
    Click Element  ${xpath_shutdown_button}
    Wait Until Page Contains Element  ${xpath_confirm_button}  timeout=10
    Click Element  ${xpath_confirm_button}
    Wait Until Keyword Succeeds  3 min  15 sec  Element Should Contain  ${xpath_current_power_state}  Off


Verify Orderly Shutdown
    [Documentation]  Verify shutdown after clicking orderly shutdown button.
    [Tags]  Verify_Orderly_Shutdown
    [Setup]  Run Keywords  Redfish Power On  stack_mode=skip  AND  Launch Browser And Login GUI
    ...  AND  Navigate to Server Power Operation Page

    Click Element At Coordinates  ${xpath_shutdown_orderly_radio}  0  0
    Click Element  ${xpath_shutdown_button}
    Wait Until Page Contains Element  ${xpath_confirm_button}  timeout=10
    Click Element  ${xpath_confirm_button}
    Wait Until Keyword Succeeds  10 min  15 sec  Element Should Contain  ${xpath_current_power_state}  Off


Verify Existence Of All Sections In Server Power Operations Page
    [Documentation]  Verify existence of all sections in Server Power Operations page.
    [Tags]  Verify_Existence_Of_All_Sections_In_Server_Power_Operations_Page

    # Added a delay for the page to load boot settings section.
    Wait Until Page Contains  Server power operations  timeout=5
    Page Should Contain  Current status
    Page Should Contain  Operations
    Page Should Contain  Settings


Verify Existence Of All Input Boxes In Host Os Boot Settings
    [Documentation]  Verify existence of all input boxes in host os boot settings.
    [Tags]  Verify_Existence_Of_All_Input_Boxes_In_Host_Os_Boot_Settings

    # Added a delay for the page to load boot settings section.
    Wait Until Page Contains  Boot settings  timeout=5
    Page Should Contain Element  ${xpath_enable_onetime_boot_checkbox}
    Page Should Contain Element  ${xpath_boot_option_select}


Verify System State At Power Off
    [Documentation]  Verify state of the system in power off state.
    [Tags]  Verify_System_State_At_Power_Off

    Redfish Power Off  stack_mode=skip
    Page Should Contain Element  ${xpath_current_power_state}
    Element Should Contain   ${xpath_current_power_state}  Off


Verify System State At Power On
    [Documentation]  Verify state of the system in power on state.
    [Tags]  Verify_System_State_At_Power_On
    [Setup]  Run Keywords  Redfish Power On  stack_mode=skip  AND  Launch Browser And Login GUI
    ...  AND  Navigate to Server Power Operation Page

    Wait Until Keyword Succeeds  15 sec  5 sec   Element Should Contain   ${xpath_current_power_state}  On


Verify PowerOn Button Should Present At Power Off
    [Documentation]  Verify existence of poweron button at power off.
    [Tags]  Verify_PowerOn_Button_Should_Present_At_Power_Off

    Redfish Power Off  stack_mode=skip
    # TODO: Implement power off using GUI later.
    Page Should Contain Element  ${xpath_poweron_button}


Verify Shutdown And Reboot Buttons Presence At Power On
    [Documentation]  Verify existence of shutdown and reboot buttons at power on.
    [Tags]  Verify_Shutdown_And_Reboot_Buttons_Presence_At_Power_On
    [Setup]  Run Keywords  Redfish Power On  stack_mode=skip  AND  Launch Browser And Login GUI
    ...  AND  Navigate to Server Power Operation Page

    # TODO: Implement power on using GUI later.
    Page Should Contain Element  ${xpath_shutdown_button}
    Page Should Contain Element  ${xpath_reboot_button}


Verify Host Immediate Reboot
    [Documentation]  Verify host reboot after triggering immediate reboot.
    [Tags]  Verify_Host_Immediate_Reboot
    [Setup]  Run Keywords  Redfish Power On  stack_mode=skip  AND  Launch Browser And Login GUI
    ...  AND  Navigate to Server Power Operation Page

    Click Element At Coordinates  ${xpath_reboot_immediate_radio}  0  0
    Click Element  ${xpath_reboot_button}
    Wait Until Page Contains Element  ${xpath_confirm_button}  timeout=10
    Click Element  ${xpath_confirm_button}
    Wait Until Keyword Succeeds  3 min  2 sec  Element Should Contain  ${xpath_current_power_state}  Off
    Click Element  ${xpath_refresh_button}
    Wait Until Keyword Succeeds  10 min  15 sec  Element Should Contain  ${xpath_current_power_state}  On


Verify Host Orderly Reboot
    [Documentation]  Verify host reboot after triggering orderly reboot.
    [Tags]  Verify_Host_Orderly_Reboot
    [Setup]  Run Keywords  Redfish Power On  stack_mode=skip  AND  Launch Browser And Login GUI
    ...  AND  Navigate to Server Power Operation Page

    Click Element  ${xpath_reboot_button}
    # Delay for confirm button to appear.
    Sleep  5s
    Wait Until Element Is Visible  ${xpath_confirm_button}  timeout=10
    Click Element  ${xpath_confirm_button}
    Wait Until Keyword Succeeds  2 min  1 sec  Is Server Status Off
    Click Element  ${xpath_refresh_button}
    Wait Until Keyword Succeeds  10 min  15 sec  Element Should Contain  ${xpath_current_power_state}  On


*** Keywords ***

Navigate to Server Power Operation Page
    [Documentation]  Go to server power operation page.

    Click Element  ${xpath_operations_menu}
    Click Element  ${xpath_server_power_operations_sub_menu}
    Wait Until Keyword Succeeds  30 sec  10 sec  Location Should Contain  server-power-operations
    Wait Until Element Is Not Visible   ${xpath_page_loading_progress_bar}  timeout=30

Is Server Status Off
    [Documentation]  Perform GUI refresh and verify server status to Off.

    Refresh GUI
    Element Should Contain  ${xpath_current_power_state}  Off
