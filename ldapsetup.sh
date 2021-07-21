!#/bin/bash
yum -y install openldap-servers openldap-clients 2>/dev/null
cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG 2>/dev/null
chown ldap. /var/lib/ldap/DB_CONFIG 2>/dev/null
systemctl start slapd 
systemctl enable slapd
ldapadd -Y EXTERNAL -H ldapi:/// -f /vagrant/chrootpw.ldif 2>/dev/null
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif 2>/dev/null
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif 2>/dev/null
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif 2>/dev/null
ldapmodify -Y EXTERNAL -H ldapi:/// -f /vagrant/chdomain.ldif 2>/dev/null
ldapadd -x -D cn=Manager,dc=srv,dc=world -W -f /vagrant/basedomain.ldif 2>/dev/null
firewall-cmd --add-service=ldap --permanent 2>/dev/null
firewall-cmd --reload 2>/dev/null
