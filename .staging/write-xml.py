import codecs

SID = 'S-1-5-21-74642-3284969411-2123768488-2802703'

xml = '''<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.4" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Description>Ensure headroom-proxy Docker container is running.</Description>
  </RegistrationInfo>
  <Triggers>
    <LogonTrigger>
      <Enabled>true</Enabled>
      <UserId>__SID__</UserId>
      <Delay>PT60S</Delay>
      <Repetition>
        <Interval>PT10M</Interval>
        <Duration>PT1H</Duration>
        <StopAtDurationEnd>true</StopAtDurationEnd>
      </Repetition>
    </LogonTrigger>
  </Triggers>
  <Principals>
    <Principal id="Author">
      <UserId>__SID__</UserId>
      <LogonType>InteractiveToken</LogonType>
      <RunLevel>LeastPrivilege</RunLevel>
    </Principal>
  </Principals>
  <Settings>
    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>
    <StartWhenAvailable>true</StartWhenAvailable>
    <Hidden>true</Hidden>
    <RestartOnFailure>
      <Interval>PT1M</Interval>
      <Count>3</Count>
    </RestartOnFailure>
  </Settings>
  <Actions Context="Author">
    <Exec>
      <Command>cmd.exe</Command>
      <Arguments>/c "C:\\Program Files\\Docker\\Docker\\resources\\bin\\docker.exe" start headroom-proxy</Arguments>
    </Exec>
  </Actions>
</Task>
'''.replace('__SID__', SID)

with open(r'c:\D\oriz\.staging\docker-headroom-ensure.xml', 'wb') as f:
    f.write(codecs.BOM_UTF16_LE + xml.encode('utf-16-le'))

print('OK')
