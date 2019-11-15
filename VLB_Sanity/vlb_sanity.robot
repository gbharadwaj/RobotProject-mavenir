*** Setting ***
Resource    MavKeywords.robot
Variables    MavVariables.py
Library    SSHLibrary
Library    Collections 

*** Test Cases ***
CheckVLBstatus
    @{vlblist}=    QueryVNFM    select d.VM_Name,v.Fixed_ip_address from Deployment_Table d ,VM_Resource_Details v where v.DeploymentId = d.Id and v.connectionPointIndex like '%OAM%' and v.connectionPointIndex not like '%SDNS%' and v.connectionPointIndex like '%RE%' and d.VM_Name like '%SIP%'
    :FOR    ${vlb}    IN    @{vlblist}
    \    &{vlb_readShm}=    readShm    ${vlb.Fixed_ip_address} 
    \    Log Many    &{vlb_readShm}
    \    Dictionary Should Contain Value    ${vlb_readShm}    Configured Active    
    \    Dictionary Should Contain Value    ${vlb_readShm}    Start Success
    
CheckExt_ip
    @{vlblist}=    QueryVNFM    select d.VM_Name,v.Fixed_ip_address from Deployment_Table d ,VM_Resource_Details v where v.DeploymentId = d.Id and v.connectionPointIndex like '%OAM%' and v.connectionPointIndex not like '%SDNS%' and v.connectionPointIndex like '%RE%' and d.VM_Name like '%SIP%'
    :FOR    ${vlb}    IN    @{vlblist}
    \    ${ext_ip_out}=    cli    ${vlb.Fixed_ip_address}    show table sys platform ext_ip
    \    log    ${ext_ip_out}                
CheckPeer_vnf 
     @{vlblist}=    QueryVNFM    select d.VM_Name,v.Fixed_ip_address from Deployment_Table d ,VM_Resource_Details v where v.DeploymentId = d.Id and v.connectionPointIndex like '%OAM%' and v.connectionPointIndex not like '%SDNS%' and v.connectionPointIndex like '%RE%' and d.VM_Name like '%SIP%'
    :FOR    ${vlb}    IN    @{vlblist}
    \    ${peer_vnf_out}=    cli    ${vlb.Fixed_ip_address}    show table sys platform peer_vnf
    \    log    ${peer_vnf_out}
CheckPeer_ip
    @{vlblist}=    QueryVNFM    select d.VM_Name,v.Fixed_ip_address from Deployment_Table d ,VM_Resource_Details v where v.DeploymentId = d.Id and v.connectionPointIndex like '%OAM%' and v.connectionPointIndex not like '%SDNS%' and v.connectionPointIndex like '%RE%' and d.VM_Name like '%SIP%'
    :FOR    ${vlb}    IN    @{vlblist}
    \    ${peer_ip_out}=    cli    ${vlb.Fixed_ip_address}    show table sys platform peer_ip
    \    log    ${peer_ip_out}
               