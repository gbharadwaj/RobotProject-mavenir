*** Setting ***
Documentation    Define generic methods/functions to be used across diff teams
Library    SSHLibrary
Library    re
Library    Collections
Library    String
Library    DateTime
Library    requests

Variables    MavVariables.py
*** Keyword ***
QueryVNFM
    [Documentation]	This keyword queries VNFM db. Return value data structure = [{},{},{},{},.......]
    [Arguments]    ${statement}
    Open Connection    ${VNFM_IP}
    login    ${VNFM_username}    ${VNFM_password}
    ${Query_result}=    Execute Command    mysql -uroot -pmavenir VnfmDB -e "${statement}";
    @{rowsReturned}=    manipulateQueryResult    ${Query_result}
    [Return]    @{rowsReturned}

QueryCMS
    [Documentation]     This keyword queries CMS db. Return value data structure = [{},{},{},{},.......]
    [Arguments]    ${statement}
    Open Connection    ${CMS_IP}
    login    ${CMS_username}    ${CMS_password}
    ${Query_result}=    Execute Command    mysql -ucontrolDb -pmavenir cms -e "${statement}";
    @{rowsReturned}=    manipulateQueryResult    ${Query_result}
    [Return]    @{rowsReturned}

manipulateQueryResult
    [Documentation]	This keyword converts str data to a list containing dictionaries
    [Arguments]    ${queryResult}
    @{returnResult}=    Create List
    @{rows_with_header}=    Split String    ${queryResult}    \n
    @{rows}=    Get Slice From List    ${rows_with_header}    1
    @{columns}=    Split String    ${rows_with_header[0]}    \t
    :FOR    ${eachrow}    IN    @{rows}
    \    &{rowDict}=    Create Dictionary
    \    @{rowData}=    Split String    ${eachrow}    \t
    \    ${rowDict}    handleRow    ${columns}    ${rowData}    ${rowDict}
    \    Append To List    ${returnResult}    ${rowDict}
    [Return]    @{returnResult}

handleRow
    [Arguments]    ${columns}    ${rowData}    ${rowDict}
    @{returnResult}=    Create List
    :FOR    ${columnname}    ${value}    IN ZIP    ${columns}    ${rowData}
    \    Set To Dictionary    ${rowDict}    ${columnname}=${value}
    [Return]    ${rowDict}
    
readShm
    [Arguments]    ${VNF_IP}
    Open Connection    ${VNFM_IP}
    Login    ${VNFM_username}    ${VNFM_password}
    ${readShm_out}=    Execute Command    ssh ${VNF_IP} /usr/IMS/current/bin/readShm
    &{readShm_data}=    Create Dictionary
    @{readShm_lines}=     Split String    ${readShm_out}    \n
    :FOR    ${item}    IN    @{readShm_lines}  
    \    #\    log    ${item}
    \    Continue For Loop If    '------------' in '${item}'
    \    @{row}=    Split String    ${item}    :
    \    ${key}=    Strip String    @{row}[0]    
    \    ${value}=    Strip String    @{row}[1]        
    \    Set To Dictionary    ${readShm_data}    ${key}=${value}    
    [Return]    &{readShm_data}
    
cli
    [Arguments]    ${VNF_IP}    ${command}
    Open Connection    ${VNFM_IP}
    Login    ${VNFM_username}    ${VNFM_password}
    ${cli_out}=    Execute Command    ssh ${VNF_IP} "echo ${command}|cli"    
    log    ${cli_out}
    @{cli_lines}=     Split String    ${cli_out}    \n    
    @{result_list}=    Get Slice From List    ${cli_lines}    3    -2
    ${result}=    Set Variable    \
    :FOR    ${item}    IN    @{result_list}
    \    ${result}    Catenate    ${result}    ${item}         
    #${result}=    Catenate    ${result_list}
    log    ${result}    
    [return]    ${result}  
