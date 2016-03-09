% this script sends an email to trigger@recipe.ifttt.com that uses the
% subject and body of email information to send a message from the phone to
% someone (yourself) informing that the simulation has finished; See IFTTT
% app (If This Then That)

sender  = 'nickuervo@gmail.com'; %Your GMail email address
psswd = 'woqxoixrwakhgywn';  %Your GMail password

setpref('Internet','E_mail',sender);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',sender);
setpref('Internet','SMTP_Password',psswd);

props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', ...
                  'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

sendmail('trigger@recipe.ifttt.com' , getenv('computername'), [' ' video_name ' using  ' sheet ' aproximation.']);
sendmail('nickuervo@gmail.com' , getenv('computername'), [' ' video_name ' using  ' sheet ' aproximation.']);




