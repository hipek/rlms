require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FwRuleParser do
  it "should have ip table rule" do
    @rule = FwRuleParser.new '-A INPUT -i lo -j ACCEPT'
    @rule.ip_table_rule.should match(/-A INPUT -i lo -j ACCEPT/)
  end
  
  it "should return valid rule" do
    @rule = FwRuleParser.new('-A INPUT -i lo -j ACCEPT').parse
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('INPUT')
    @rule.in_int.should eql('lo')
    @rule.target.should eql('ACCEPT')
    
    @rule.out_int.should be_nil
    @rule.src_ip.should be_nil
    @rule.dest_ip.should be_nil
    @rule.src_port.should be_nil
    @rule.dest_port.should be_nil
    @rule.to_ipt.should == '-A INPUT -i lo -j ACCEPT'

    @rule = FwRuleParser.new('-t filter -A INPUT -s 80.92.12.12 -d 10.5.5.200 -i eth0 -p icmp -j ACCEPT').parse
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('INPUT')
    @rule.src_ip.should eql('80.92.12.12')
    @rule.dest_ip.should eql('10.5.5.200')
    @rule.in_int.should eql('eth0')
    @rule.protocol.should eql('icmp')
    @rule.target.should eql('ACCEPT')
    @rule.to_ipt.should == '-t filter -A INPUT -s 80.92.12.12 -d 10.5.5.200 -i eth0 -p icmp -j ACCEPT'
  end

  it "should return valid rule with out int" do
    @rule = FwRuleParser.new('-A OUTPUT -s 10.5.5.100 -d 255.255.255.255 -o eth0 -p udp -m udp --sport 67 --dport 68 -j ACCEPT').parse
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('OUTPUT')
    @rule.src_ip.should eql('10.5.5.100')
    @rule.dest_ip.should eql('255.255.255.255')
    @rule.out_int.should eql('eth0')
    @rule.protocol.should eql('udp')
    @rule.mod_protocol.should eql('udp')
    @rule.mod.should be_nil
    @rule.src_port.should eql('67')
    @rule.dest_port.should eql('68')
    @rule.target.should eql('ACCEPT')
    @rule.to_ipt.should == '-A OUTPUT -s 10.5.5.100 -d 255.255.255.255 -o eth0 -p udp -m udp --sport 67 --dport 68 -j ACCEPT'
  end

  it "should return valid rule with mark" do
    @rule = FwRuleParser.new('-A OUTPUT -d 10.5.5.50 -o eth0 -p tcp -m tcp --sport 8080 -j MARK --set-mark 0x64').parse
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('OUTPUT')
    @rule.src_ip.should be_nil
    @rule.dest_ip.should eql('10.5.5.50')
    @rule.in_int.should be_nil
    @rule.out_int.should eql('eth0')
    @rule.protocol.should eql('tcp')
    @rule.mod_protocol.should eql('tcp')
    @rule.src_port.should eql('8080')
    @rule.dest_port.should be_nil
    @rule.target.should eql('MARK')
    @rule.aft_argument.should eql('0x64')
    @rule.to_ipt.should == '-A OUTPUT -d 10.5.5.50 -o eth0 -p tcp -m tcp --sport 8080 -j MARK --set-mark 0x64'
  end
end

describe FwRuleParser, "INPUT" do
  it "should return valid rule for '-A INPUT -d 10.5.5.200 -i eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT'" do
    @rule = FwRuleParser.new('-A INPUT -d 10.5.5.200 -i eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT').parse
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('INPUT')
    @rule.dest_ip.should eql("10.5.5.200")
    @rule.in_int.should eql('eth0')
    @rule.out_int.should be_nil
    @rule.protocol.should be_nil
    @rule.mod.should eql('state')
    @rule.mod_option.should eql('--state RELATED,ESTABLISHED')
    @rule.mod_protocol.should be_nil
    @rule.dest_port.should be_nil
    @rule.target.should eql('ACCEPT')
    @rule.aft_argument.should be_nil
    @rule.to_ipt.should == '-A INPUT -d 10.5.5.200 -i eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT'
  end

  it "should return valid rule for '-A INPUT -d 10.5.5.200 -i eth0 -p tcp -m state --state NEW,RELATED,ESTABLISHED -m tcp --dport 5269 -j ACCEPT'" do
    @rule = FwRuleParser.new('-A INPUT -d 10.5.5.200 -i eth0 -p tcp -m state --state NEW,RELATED,ESTABLISHED -m tcp --dport 5269 -j ACCEPT').parse
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('INPUT')
    @rule.dest_ip.should eql("10.5.5.200")
    @rule.in_int.should eql('eth0')
    @rule.out_int.should be_nil
    @rule.protocol.should eql('tcp')
    @rule.mod.should eql('state')
    @rule.mod_protocol.should eql('tcp')
    @rule.mod_option.should eql('--state NEW,RELATED,ESTABLISHED')
    @rule.dest_port.should eql("5269")
    @rule.target.should eql('ACCEPT')
    @rule.aft_argument.should be_nil 
    @rule.to_ipt.should == '-A INPUT -d 10.5.5.200 -i eth0 -p tcp -m state --state NEW,RELATED,ESTABLISHED -m tcp --dport 5269 -j ACCEPT'
  end

  it "should return valid rule for '-A INPUT -d 10.5.5.200 -i eth0 -p tcp -m state --state NEW,RELATED,ESTABLISHED -m tcp --dport 7777:7778 -j ACCEPT'" do
    @rule = FwRuleParser.new('-A INPUT -d 10.5.5.200 -i eth0 -p tcp -m state --state NEW,RELATED,ESTABLISHED -m tcp --dport 7777:7778 -j ACCEPT').parse
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('INPUT')
    @rule.dest_ip.should eql("10.5.5.200")
    @rule.in_int.should eql('eth0')
    @rule.out_int.should be_nil
    @rule.mod.should eql('state')
    @rule.mod_protocol.should eql('tcp')
    @rule.mod_option.should eql('--state NEW,RELATED,ESTABLISHED')
    @rule.dest_port.should eql("7777:7778")
    @rule.target.should eql('ACCEPT')
    @rule.aft_argument.should be_nil
    @rule.to_ipt.should == '-A INPUT -d 10.5.5.200 -i eth0 -p tcp -m state --state NEW,RELATED,ESTABLISHED -m tcp --dport 7777:7778 -j ACCEPT'
  end

  it "should return valid rule for '-A INPUT -s 10.0.0.0/255.0.0.0 -i eth0 -j ACCEPT'" do
    @rule = FwRuleParser.new('-A INPUT -s 10.0.0.0/255.0.0.0 -i eth0 -j ACCEPT').parse
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('INPUT')
    @rule.src_ip.should eql('10.0.0.0/255.0.0.0')
    @rule.dest_ip.should be_nil
    @rule.in_int.should eql('eth0')
    @rule.out_int.should be_nil
    @rule.target.should eql('ACCEPT')
    @rule.aft_argument.should be_nil
    @rule.to_ipt.should == '-A INPUT -s 10.0.0.0/255.0.0.0 -i eth0 -j ACCEPT'
  end

  it "should return valid rule for '-A INPUT -j drop-and-log-it'" do
    @rule = FwRuleParser.new('-A INPUT -j drop-and-log-it').parse
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('INPUT')
    @rule.target.should eql('drop-and-log-it')
    @rule.to_ipt.should == '-A INPUT -j drop-and-log-it'
  end

  it "should return valid rule for '-A INPUT -s 10.0.0.0 -i eth0 -j drop-and-log-it'" do
    @rule = FwRuleParser.new('-A INPUT -s 10.0.0.0 -i eth0 -j drop-and-log-it').parse
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('INPUT')
    @rule.src_ip.should eql('10.0.0.0')
    @rule.in_int.should eql('eth0')
    @rule.target.should eql('drop-and-log-it')
    @rule.to_ipt.should == '-A INPUT -s 10.0.0.0 -i eth0 -j drop-and-log-it'
  end

  it "should return valid rule for '-A INPUT -s 89.171.148.82 -i eth0 -p tcp -m tcp --dport 80 -j DROP'" do
    @rule = FwRuleParser.new('-A INPUT -s 89.171.148.82 -i eth0 -p tcp -m tcp --dport 80 -j DROP').parse
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('INPUT')
    @rule.src_ip.should eql('89.171.148.82')
    @rule.dest_ip.should be_nil
    @rule.in_int.should eql('eth0')
    @rule.out_int.should be_nil
    @rule.protocol.should eql('tcp')
    @rule.mod.should be_nil
    @rule.mod_protocol.should eql('tcp')
    @rule.src_port.should be_nil
    @rule.dest_port.should eql('80')
    @rule.target.should eql('DROP')
    @rule.aft_argument.should be_nil
    @rule.to_ipt.should == '-A INPUT -s 89.171.148.82 -i eth0 -p tcp -m tcp --dport 80 -j DROP'
  end
end

describe FwRuleParser, "FORWARD" do
  it "should return valid rule for '-A FORWARD -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu'" do
    @rule = FwRuleParser.new('-A FORWARD -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu').parse
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('FORWARD')
    @rule.src_ip.should be_nil
    @rule.dest_ip.should be_nil
    @rule.in_int.should be_nil
    @rule.out_int.should be_nil
    @rule.protocol.should eql('tcp')
    @rule.mod.should be_nil
    @rule.mod_protocol.should eql('tcp')
    @rule.mod_option.should be_nil
    @rule.src_port.should be_nil
    @rule.dest_port.should be_nil
    @rule.target.should eql('TCPMSS')
    @rule.aft_option.should eql('--clamp-mss-to-pmtu')
    @rule.aft_argument.should be_nil
    @rule.tcp_flags.should eql('SYN,RST SYN')
    @rule.tcp_flags_option.should be_nil
    @rule.to_ipt.should == '-A FORWARD -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu'
  end

  it "should return valid rule for '-A FORWARD -s 10.5.5.1 -p tcp -m tcp --dport 1024:65535 --tcp-flags FIN,SYN,RST,ACK SYN -m connlimit --connlimit-above 300 --connlimit-mask 32 -j drop-and-log-it'" do
    @rule = FwRuleParser.new('-A FORWARD -s 10.5.5.1 -p tcp -m tcp --dport 1024:65535 --tcp-flags FIN,SYN,RST,ACK SYN -m connlimit --connlimit-above 300 --connlimit-mask 32 -j drop-and-log-it').parse
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('FORWARD')
    @rule.src_ip.should eql('10.5.5.1')
    @rule.dest_ip.should be_nil
    @rule.in_int.should be_nil
    @rule.out_int.should be_nil
    @rule.protocol.should eql('tcp')
    @rule.mod.should be_nil
    @rule.mod_protocol.should eql('tcp')
    @rule.mod_option.should be_nil
    @rule.src_port.should be_nil
    @rule.dest_port.should eql('1024:65535')
    @rule.target.should eql('drop-and-log-it')
    @rule.aft_argument.should be_nil
    @rule.tcp_flags.should eql('FIN,SYN,RST,ACK SYN')
    @rule.tcp_flags_option.should eql('-m connlimit --connlimit-above 300 --connlimit-mask 32')
    @rule.to_ipt.should == '-A FORWARD -s 10.5.5.1 -p tcp -m tcp --dport 1024:65535 --tcp-flags FIN,SYN,RST,ACK SYN -m connlimit --connlimit-above 300 --connlimit-mask 32 -j drop-and-log-it'
  end

  it "should return valid rule for '-A FORWARD -i eth0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT'" do
    @rule = FwRuleParser.new('-A FORWARD -i eth1 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT').parse
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('FORWARD')
    @rule.src_ip.should be_nil
    @rule.dest_ip.should be_nil
    @rule.in_int.should eql('eth1')
    @rule.out_int.should eql('eth0')
    @rule.protocol.should be_nil
    @rule.mod.should eql('state')
    @rule.mod_option.should eql('--state RELATED,ESTABLISHED')
    @rule.src_port.should be_nil
    @rule.dest_port.should be_nil
    @rule.target.should eql('ACCEPT')
    @rule.aft_argument.should be_nil    
    @rule.to_ipt.should == '-A FORWARD -i eth1 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT'
  end

  it "should return valid rule for '-A FORWARD -d 10.5.5.1 -p tcp -m tcp --dport 1551:1555 -j ACCEPT'" do
    @rule = FwRuleParser.new('-A FORWARD -d 10.5.5.1 -p tcp -m tcp --dport 1551:1555 -j ACCEPT').parse
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('FORWARD')
    @rule.src_ip.should be_nil
    @rule.dest_ip.should eql('10.5.5.1')
    @rule.in_int.should be_nil
    @rule.out_int.should be_nil
    @rule.protocol.should eql('tcp')
    @rule.mod.should be_nil
    @rule.mod_protocol.should eql('tcp')
    @rule.src_port.should be_nil
    @rule.dest_port.should eql('1551:1555')
    @rule.target.should eql('ACCEPT')
    @rule.aft_argument.should be_nil
    @rule.to_ipt.should == '-A FORWARD -d 10.5.5.1 -p tcp -m tcp --dport 1551:1555 -j ACCEPT'
  end

  it "should return valid rule for '-A FORWARD -j lstat'" do
    @rule = FwRuleParser.new('-A FORWARD -j lstat').parse
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('FORWARD')
    @rule.target.should eql('lstat')
    @rule.to_ipt.should == '-A FORWARD -j lstat'
  end

  it "should return valid rule for '-A FORWARD -i eth0 -o eth0 -j ACCEPT'" do
    @rule = FwRuleParser.new('-A FORWARD -i eth2 -o eth0 -j ACCEPT').parse
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('FORWARD')
    @rule.in_int.should eql('eth2')
    @rule.out_int.should eql('eth0')
    @rule.target.should eql('ACCEPT')
    @rule.to_ipt.should == '-A FORWARD -i eth2 -o eth0 -j ACCEPT'
  end
end

describe FwRuleParser, "OUTPUT" do
  it "should return valid rule for '-A OUTPUT -s 10.5.5.200 -o eth0 -p tcp -m state --state NEW,RELATED,ESTABLISHED -m tcp --sport 20 -j ACCEPT'" do
    @rule = FwRuleParser.new('-A OUTPUT -s 10.5.5.200 -o eth0 -p tcp -m state --state NEW,RELATED,ESTABLISHED -m tcp --sport 20 -j ACCEPT').parse
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('OUTPUT')
    @rule.src_ip.should eql('10.5.5.200')
    @rule.dest_ip.should be_nil
    @rule.in_int.should be_nil
    @rule.out_int.should eql('eth0')
    @rule.protocol.should eql('tcp')
    @rule.mod.should eql('state')
    @rule.mod_protocol.should eql('tcp')
    @rule.mod_option.should eql('--state NEW,RELATED,ESTABLISHED')
    @rule.target.should eql('ACCEPT')
    @rule.aft_argument.should be_nil    
    @rule.to_ipt.should == '-A OUTPUT -s 10.5.5.200 -o eth0 -p tcp -m state --state NEW,RELATED,ESTABLISHED -m tcp --sport 20 -j ACCEPT'
  end

  it "should return valid rule for '-A OUTPUT -d 10.0.0.0/255.0.0.0 -o eth0 -j drop-and-log-it'" do
    @rule = FwRuleParser.new('-A OUTPUT -d 10.0.0.0/255.0.0.0 -o eth0 -j drop-and-log-it').parse
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('OUTPUT')
    @rule.dest_ip.should eql('10.0.0.0/255.0.0.0')
    @rule.in_int.should be_nil
    @rule.out_int.should eql('eth0')
    @rule.target.should eql('drop-and-log-it')
    @rule.aft_argument.should be_nil
    @rule.to_ipt.should == '-A OUTPUT -d 10.0.0.0/255.0.0.0 -o eth0 -j drop-and-log-it'
  end

  it "should return valid rule for '-A OUTPUT -s 10.5.5.200/24 -d 10.0.0.0/255.0.0.0 -o eth0 -j ACCEPT'" do
    @rule = FwRuleParser.new('-A OUTPUT -s 10.5.5.200/24 -d 10.0.0.0/255.0.0.0 -o eth0 -j ACCEPT').parse
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('OUTPUT')
    @rule.src_ip.should eql('10.5.5.200/24')
    @rule.dest_ip.should eql('10.0.0.0/255.0.0.0')
    @rule.in_int.should be_nil
    @rule.out_int.should eql('eth0')
    @rule.target.should eql('ACCEPT')
    @rule.aft_argument.should be_nil
    @rule.to_ipt.should == '-A OUTPUT -s 10.5.5.200/24 -d 10.0.0.0/255.0.0.0 -o eth0 -j ACCEPT'
  end

  it "should return valid rule for '-A OUTPUT -s 10.5.5.200 -o eth0 -j ACCEPT'" do
    @rule = FwRuleParser.new('-A OUTPUT -s 10.5.5.200 -o eth0 -j ACCEPT').parse
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('OUTPUT')
    @rule.src_ip.should eql('10.5.5.200')
    @rule.dest_ip.should be_nil
    @rule.in_int.should be_nil
    @rule.out_int.should eql('eth0')
    @rule.target.should eql('ACCEPT')
    @rule.aft_argument.should be_nil
    @rule.to_ipt.should == '-A OUTPUT -s 10.5.5.200 -o eth0 -j ACCEPT'
  end

  it "should return valid rule for '-A OUTPUT -s 10.5.5.100 -d 255.255.255.255 -o eth0 -p tcp -m tcp --sport 67 --dport 68 -j ACCEPT'" do
    @rule = FwRuleParser.new('-A OUTPUT -s 10.5.5.100 -d 255.255.255.255 -o eth0 -p tcp -m tcp --sport 67 --dport 68 -j ACCEPT').parse
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('OUTPUT')
    @rule.src_ip.should eql('10.5.5.100')
    @rule.dest_ip.should eql('255.255.255.255')
    @rule.in_int.should be_nil
    @rule.out_int.should eql('eth0')
    @rule.protocol.should eql('tcp')
    @rule.mod_protocol.should eql('tcp')
    @rule.mod.should be_nil
    @rule.src_port.should eql('67')
    @rule.dest_port.should eql('68')
    @rule.target.should eql('ACCEPT')
    @rule.aft_argument.should be_nil
    @rule.to_ipt.should == '-A OUTPUT -s 10.5.5.100 -d 255.255.255.255 -o eth0 -p tcp -m tcp --sport 67 --dport 68 -j ACCEPT'
  end  
end

describe FwRuleParser, "PREROUTING" do
  it "should return valid rule for '-A PREROUTING -d 10.5.5.200 -i eth0 -p tcp -m tcp --dport 1550 -j DNAT --to-destination 10.5.5.4:1550'" do
    @rule = FwRuleParser.new('-A PREROUTING -d 10.5.5.200 -i eth0 -p tcp -m tcp --dport 1550 -j DNAT --to-destination 10.5.5.4:1550').parse
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('PREROUTING')
    @rule.dest_ip.should eql('10.5.5.200')
    @rule.in_int.should eql('eth0')
    @rule.protocol.should eql('tcp')
    @rule.mod_protocol.should eql('tcp')
    @rule.mod.should be_nil
    @rule.dest_port.should eql('1550')
    @rule.target.should eql('DNAT')
    @rule.aft_option.should eql('--to-destination')
    @rule.aft_argument.should eql('10.5.5.4:1550')
    @rule.to_ipt.should == '-A PREROUTING -d 10.5.5.200 -i eth0 -p tcp -m tcp --dport 1550 -j DNAT --to-destination 10.5.5.4:1550'
  end

  it "should return valid rule for '-A PREROUTING -d 10.5.5.200 -i eth0 -p udp -m udp --dport 6112:6119 -j DNAT --to-destination 10.5.5.1'" do
    @rule = FwRuleParser.new('-A PREROUTING -d 10.5.5.200 -i eth0 -p udp -m udp --dport 6112:6119 -j DNAT --to-destination 10.5.5.1').parse
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('PREROUTING')
    @rule.dest_ip.should eql('10.5.5.200')
    @rule.in_int.should eql('eth0')
    @rule.protocol.should eql('udp')
    @rule.mod.should be_nil
    @rule.mod_protocol.should eql('udp')
    @rule.target.should eql('DNAT')
    @rule.aft_option.should eql('--to-destination')
    @rule.aft_argument.should eql('10.5.5.1')
    @rule.to_ipt.should == '-A PREROUTING -d 10.5.5.200 -i eth0 -p udp -m udp --dport 6112:6119 -j DNAT --to-destination 10.5.5.1'
  end
end

describe FwRuleParser, "POSTROUTING" do
  it "should return valid rule for '-A POSTROUTING -s 10.5.5.1 -o eth0 -j SNAT --to-source 10.5.5.200'" do
    @rule = FwRuleParser.new('-A POSTROUTING -s 10.5.5.1 -o eth0 -j SNAT --to-source 10.5.5.200').parse
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('POSTROUTING')
    @rule.src_ip.should eql('10.5.5.1')
    @rule.out_int.should eql('eth0')
    @rule.target.should eql('SNAT')
    @rule.aft_option.should eql('--to-source')
    @rule.aft_argument.should eql('10.5.5.200')
    @rule.to_ipt.should == '-A POSTROUTING -s 10.5.5.1 -o eth0 -j SNAT --to-source 10.5.5.200'
  end

  it "should return valid rule for '-A POSTROUTING -o eth0 -j MYSHAPER-OUT'" do
    @rule = FwRuleParser.new('-A POSTROUTING -o eth0 -j MYSHAPER-OUT').parse
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('POSTROUTING')
    @rule.out_int.should eql('eth0')
    @rule.target.should eql('MYSHAPER-OUT')
    @rule.aft_argument.should be_nil
    @rule.to_ipt.should == '-A POSTROUTING -o eth0 -j MYSHAPER-OUT'
  end
end

describe FwRuleParser, "MARK" do
  skip "should return valid rule for '-A MYSHAPER-IN ! -p tcp -j MARK --set-mark 0x1e'" do
    # pending
    @rule = FwRuleParser.new('-t MANGLE -A MYSHAPER-IN ! -p tcp -j MARK --set-mark 0x1e').parse    
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('MYSHAPER-IN')
    @rule.protocol.should eql('tcp')
    @rule.mod.should be_nil
    @rule.mod_option.should be_nil
    @rule.mod_protocol.should be_nil
    @rule.target.should eql('MARK')
    @rule.aft_option.should eql('--set-mark')
    @rule.aft_argument.should eql('0x1e')
    @rule.to_ipt.should == '-t MANGLE -A MYSHAPER-IN ! -p tcp -j MARK --set-mark 0x1e'
  end

  it "should return valid rule for '-A MYSHAPER-IN -m mark --mark 0x0 -j MARK --set-mark 0x23'" do
    @rule = FwRuleParser.new('-A MYSHAPER-IN -m mark --mark 0x0 -j MARK --set-mark 0x23').parse    
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('MYSHAPER-IN')
    @rule.protocol.should be_nil
    @rule.mod.should eql('mark')
    @rule.mod_option.should eql('--mark 0x0')
    @rule.mod_protocol.should be_nil
    @rule.target.should eql('MARK')
    @rule.aft_option.should eql('--set-mark')
    @rule.aft_argument.should eql('0x23')
    @rule.to_ipt.should == '-A MYSHAPER-IN -m mark --mark 0x0 -j MARK --set-mark 0x23'
  end

  it "should return valid rule for '-A MYSHAPER-IN -j IMQ --todev 0'" do
    @rule = FwRuleParser.new('-A MYSHAPER-IN -j IMQ --todev 0').parse    
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('MYSHAPER-IN')
    @rule.protocol.should be_nil
    @rule.mod.should be_nil
    @rule.mod_option.should be_nil
    @rule.mod_protocol.should be_nil
    @rule.target.should eql('IMQ')
    @rule.aft_option.should eql('--todev')
    @rule.aft_argument.should eql('0')
    @rule.to_ipt.should == '-A MYSHAPER-IN -j IMQ --todev 0'
  end

  it "should return valid rule for '-A MYSHAPER-OUT -m layer7 --l7proto ftp -j MARK --set-mark 0x18'" do
    @rule = FwRuleParser.new('-A MYSHAPER-OUT -m layer7 --l7proto ftp -j MARK --set-mark 0x18').parse    
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('MYSHAPER-OUT')
    @rule.protocol.should be_nil
    @rule.mod.should eql('layer7')
    @rule.mod_option.should eql('--l7proto ftp')
    @rule.mod_protocol.should be_nil
    @rule.target.should eql('MARK')
    @rule.aft_option.should eql('--set-mark')
    @rule.aft_argument.should eql('0x18')
    @rule.to_ipt.should == '-A MYSHAPER-OUT -m layer7 --l7proto ftp -j MARK --set-mark 0x18'
  end

  it "should return valid rule for '-A MYSHAPER-IN -p tcp -m length --length 0:64 -j MARK --set-mark 0x1f'" do
    @rule = FwRuleParser.new('-A MYSHAPER-IN -p tcp -m length --length 0:64 -j MARK --set-mark 0x1f').parse    
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('MYSHAPER-IN')
    @rule.protocol.should eql('tcp')
    @rule.mod.should eql('length')
    @rule.mod_option.should eql('--length 0:64')
    @rule.mod_protocol.should be_nil
    @rule.target.should eql('MARK')
    @rule.aft_option.should eql('--set-mark')
    @rule.aft_argument.should eql('0x1f')
    @rule.to_ipt.should == '-A MYSHAPER-IN -p tcp -m length --length 0:64 -j MARK --set-mark 0x1f'
  end

  it "should return valid rule for '-A MYSHAPER-IN -p tcp -m tcp --dport 22 -j MARK --set-mark 0x20'" do
    @rule = FwRuleParser.new('-A MYSHAPER-IN -p tcp -m tcp --dport 22 -j MARK --set-mark 0x20').parse    
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('MYSHAPER-IN')
    @rule.protocol.should eql('tcp')
    @rule.mod.should be_nil
    @rule.mod_protocol.should eql('tcp')
    @rule.target.should eql('MARK')
    @rule.aft_option.should eql('--set-mark')
    @rule.aft_argument.should eql('0x20')
    @rule.to_ipt.should == '-A MYSHAPER-IN -p tcp -m tcp --dport 22 -j MARK --set-mark 0x20'
  end  
end

describe FwRuleParser, "CUSTOM" do
  it "should return valid rule for '-A lstat -d 10.5.5.46 -m state --state RELATED,ESTABLISHED -j ACCEPT'" do
    @rule = FwRuleParser.new('-A lstat -d 10.5.5.46 -m state --state RELATED,ESTABLISHED -j ACCEPT').parse
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('lstat')
    @rule.dest_ip.should eql('10.5.5.46')
    @rule.mod.should eql('state')
    @rule.mod_option.should eql('--state RELATED,ESTABLISHED')
    @rule.target.should eql('ACCEPT')
    @rule.aft_argument.should be_nil
    @rule.to_ipt.should == '-A lstat -d 10.5.5.46 -m state --state RELATED,ESTABLISHED -j ACCEPT'
  end

  it "should return valid rule for '-A lstat -s 10.5.5.47 -i eth0 -j ACCEPT'" do
    @rule = FwRuleParser.new('-A lstat -s 10.5.5.47 -i eth0 -j ACCEPT').parse
    @rule.cmd.should eql('A')
    @rule.chain_name.should eql('lstat')
    @rule.src_ip.should eql('10.5.5.47')
    @rule.in_int.should eql('eth0')
    @rule.target.should eql('ACCEPT')
    @rule.aft_argument.should be_nil
    @rule.to_ipt.should == '-A lstat -s 10.5.5.47 -i eth0 -j ACCEPT'
  end
end

describe FwRuleParser, "firewall" do
  #it "should read file with rules" do
  #  parser = FwRuleParser.new('')
  #  parser.read_firewall_file(RAILS_ROOT + '/script/firewall.txt')
  #end
 # it "should read rules" do
 #   parser = FwRuleParser.new('')
 #   rules = parser.read_firewall(File.read(RAILS_ROOT + '/script/firewall.txt'))
 # end
end
