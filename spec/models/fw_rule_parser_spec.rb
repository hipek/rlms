require 'rails_helper'

describe FwRuleParser do
  it "should have ip table rule" do
    @rule = FwRuleParser.new '-A INPUT -i lo -j ACCEPT'
    expect(@rule.ip_table_rule).to match(/-A INPUT -i lo -j ACCEPT/)
  end

  it "should return valid rule" do
    @rule = FwRuleParser.new('-A INPUT -i lo -j ACCEPT').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('INPUT')
    expect(@rule.in_int).to eql('lo')
    expect(@rule.target).to eql('ACCEPT')

    expect(@rule.out_int).to be_nil
    expect(@rule.src_ip).to be_nil
    expect(@rule.dest_ip).to be_nil
    expect(@rule.src_port).to be_nil
    expect(@rule.dest_port).to be_nil
    expect(@rule.to_ipt).to eq '-A INPUT -i lo -j ACCEPT'

    @rule = FwRuleParser.new('-t filter -A INPUT -s 80.92.12.12 -d 10.5.5.200 -i eth0 -p icmp -j ACCEPT').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('INPUT')
    expect(@rule.src_ip).to eql('80.92.12.12')
    expect(@rule.dest_ip).to eql('10.5.5.200')
    expect(@rule.in_int).to eql('eth0')
    expect(@rule.protocol).to eql('icmp')
    expect(@rule.target).to eql('ACCEPT')
    expect(@rule.to_ipt).to eq '-t filter -A INPUT -s 80.92.12.12 -d 10.5.5.200 -i eth0 -p icmp -j ACCEPT'
  end

  it "should return valid rule with out int" do
    @rule = FwRuleParser.new('-A OUTPUT -s 10.5.5.100 -d 255.255.255.255 -o eth0 -p udp -m udp --sport 67 --dport 68 -j ACCEPT').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('OUTPUT')
    expect(@rule.src_ip).to eql('10.5.5.100')
    expect(@rule.dest_ip).to eql('255.255.255.255')
    expect(@rule.out_int).to eql('eth0')
    expect(@rule.protocol).to eql('udp')
    expect(@rule.mod_protocol).to eql('udp')
    expect(@rule.mod).to be_nil
    expect(@rule.src_port).to eql('67')
    expect(@rule.dest_port).to eql('68')
    expect(@rule.target).to eql('ACCEPT')
    expect(@rule.to_ipt).to eq '-A OUTPUT -s 10.5.5.100 -d 255.255.255.255 -o eth0 -p udp -m udp --sport 67 --dport 68 -j ACCEPT'
  end

  it "should return valid rule with mark" do
    @rule = FwRuleParser.new('-A OUTPUT -d 10.5.5.50 -o eth0 -p tcp -m tcp --sport 8080 -j MARK --set-mark 0x64').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('OUTPUT')
    expect(@rule.src_ip).to be_nil
    expect(@rule.dest_ip).to eql('10.5.5.50')
    expect(@rule.in_int).to be_nil
    expect(@rule.out_int).to eql('eth0')
    expect(@rule.protocol).to eql('tcp')
    expect(@rule.mod_protocol).to eql('tcp')
    expect(@rule.src_port).to eql('8080')
    expect(@rule.dest_port).to be_nil
    expect(@rule.target).to eql('MARK')
    expect(@rule.aft_argument).to eql('0x64')
    expect(@rule.to_ipt).to eq '-A OUTPUT -d 10.5.5.50 -o eth0 -p tcp -m tcp --sport 8080 -j MARK --set-mark 0x64'
  end
end

describe FwRuleParser, "INPUT" do
  it "should return valid rule for '-A INPUT -d 10.5.5.200 -i eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT'" do
    @rule = FwRuleParser.new('-A INPUT -d 10.5.5.200 -i eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('INPUT')
    expect(@rule.dest_ip).to eql("10.5.5.200")
    expect(@rule.in_int).to eql('eth0')
    expect(@rule.out_int).to be_nil
    expect(@rule.protocol).to be_nil
    expect(@rule.mod).to eql('state')
    expect(@rule.mod_option).to eql('--state RELATED,ESTABLISHED')
    expect(@rule.mod_protocol).to be_nil
    expect(@rule.dest_port).to be_nil
    expect(@rule.target).to eql('ACCEPT')
    expect(@rule.aft_argument).to be_nil
    expect(@rule.to_ipt).to eq '-A INPUT -d 10.5.5.200 -i eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT'
  end

  it "should return valid rule for '-A INPUT -d 10.5.5.200 -i eth0 -p tcp -m state --state NEW,RELATED,ESTABLISHED -m tcp --dport 5269 -j ACCEPT'" do
    @rule = FwRuleParser.new('-A INPUT -d 10.5.5.200 -i eth0 -p tcp -m state --state NEW,RELATED,ESTABLISHED -m tcp --dport 5269 -j ACCEPT').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('INPUT')
    expect(@rule.dest_ip).to eql("10.5.5.200")
    expect(@rule.in_int).to eql('eth0')
    expect(@rule.out_int).to be_nil
    expect(@rule.protocol).to eql('tcp')
    expect(@rule.mod).to eql('state')
    expect(@rule.mod_protocol).to eql('tcp')
    expect(@rule.mod_option).to eql('--state NEW,RELATED,ESTABLISHED')
    expect(@rule.dest_port).to eql("5269")
    expect(@rule.target).to eql('ACCEPT')
    expect(@rule.aft_argument).to be_nil
    expect(@rule.to_ipt).to eq '-A INPUT -d 10.5.5.200 -i eth0 -p tcp -m state --state NEW,RELATED,ESTABLISHED -m tcp --dport 5269 -j ACCEPT'
  end

  it "should return valid rule for '-A INPUT -d 10.5.5.200 -i eth0 -p tcp -m state --state NEW,RELATED,ESTABLISHED -m tcp --dport 7777:7778 -j ACCEPT'" do
    @rule = FwRuleParser.new('-A INPUT -d 10.5.5.200 -i eth0 -p tcp -m state --state NEW,RELATED,ESTABLISHED -m tcp --dport 7777:7778 -j ACCEPT').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('INPUT')
    expect(@rule.dest_ip).to eql("10.5.5.200")
    expect(@rule.in_int).to eql('eth0')
    expect(@rule.out_int).to be_nil
    expect(@rule.mod).to eql('state')
    expect(@rule.mod_protocol).to eql('tcp')
    expect(@rule.mod_option).to eql('--state NEW,RELATED,ESTABLISHED')
    expect(@rule.dest_port).to eql("7777:7778")
    expect(@rule.target).to eql('ACCEPT')
    expect(@rule.aft_argument).to be_nil
    expect(@rule.to_ipt).to eq '-A INPUT -d 10.5.5.200 -i eth0 -p tcp -m state --state NEW,RELATED,ESTABLISHED -m tcp --dport 7777:7778 -j ACCEPT'
  end

  it "should return valid rule for '-A INPUT -s 10.0.0.0/255.0.0.0 -i eth0 -j ACCEPT'" do
    @rule = FwRuleParser.new('-A INPUT -s 10.0.0.0/255.0.0.0 -i eth0 -j ACCEPT').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('INPUT')
    expect(@rule.src_ip).to eql('10.0.0.0/255.0.0.0')
    expect(@rule.dest_ip).to be_nil
    expect(@rule.in_int).to eql('eth0')
    expect(@rule.out_int).to be_nil
    expect(@rule.target).to eql('ACCEPT')
    expect(@rule.aft_argument).to be_nil
    expect(@rule.to_ipt).to eq '-A INPUT -s 10.0.0.0/255.0.0.0 -i eth0 -j ACCEPT'
  end

  it "should return valid rule for '-A INPUT -j drop-and-log-it'" do
    @rule = FwRuleParser.new('-A INPUT -j drop-and-log-it').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('INPUT')
    expect(@rule.target).to eql('drop-and-log-it')
    expect(@rule.to_ipt).to eq '-A INPUT -j drop-and-log-it'
  end

  it "should return valid rule for '-A INPUT -s 10.0.0.0 -i eth0 -j drop-and-log-it'" do
    @rule = FwRuleParser.new('-A INPUT -s 10.0.0.0 -i eth0 -j drop-and-log-it').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('INPUT')
    expect(@rule.src_ip).to eql('10.0.0.0')
    expect(@rule.in_int).to eql('eth0')
    expect(@rule.target).to eql('drop-and-log-it')
    expect(@rule.to_ipt).to eq '-A INPUT -s 10.0.0.0 -i eth0 -j drop-and-log-it'
  end

  it "should return valid rule for '-A INPUT -s 89.171.148.82 -i eth0 -p tcp -m tcp --dport 80 -j DROP'" do
    @rule = FwRuleParser.new('-A INPUT -s 89.171.148.82 -i eth0 -p tcp -m tcp --dport 80 -j DROP').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('INPUT')
    expect(@rule.src_ip).to eql('89.171.148.82')
    expect(@rule.dest_ip).to be_nil
    expect(@rule.in_int).to eql('eth0')
    expect(@rule.out_int).to be_nil
    expect(@rule.protocol).to eql('tcp')
    expect(@rule.mod).to be_nil
    expect(@rule.mod_protocol).to eql('tcp')
    expect(@rule.src_port).to be_nil
    expect(@rule.dest_port).to eql('80')
    expect(@rule.target).to eql('DROP')
    expect(@rule.aft_argument).to be_nil
    expect(@rule.to_ipt).to eq '-A INPUT -s 89.171.148.82 -i eth0 -p tcp -m tcp --dport 80 -j DROP'
  end
end

describe FwRuleParser, "FORWARD" do
  it "should return valid rule for '-A FORWARD -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu'" do
    @rule = FwRuleParser.new('-A FORWARD -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('FORWARD')
    expect(@rule.src_ip).to be_nil
    expect(@rule.dest_ip).to be_nil
    expect(@rule.in_int).to be_nil
    expect(@rule.out_int).to be_nil
    expect(@rule.protocol).to eql('tcp')
    expect(@rule.mod).to be_nil
    expect(@rule.mod_protocol).to eql('tcp')
    expect(@rule.mod_option).to be_nil
    expect(@rule.src_port).to be_nil
    expect(@rule.dest_port).to be_nil
    expect(@rule.target).to eql('TCPMSS')
    expect(@rule.aft_option).to eql('--clamp-mss-to-pmtu')
    expect(@rule.aft_argument).to be_nil
    expect(@rule.tcp_flags).to eql('SYN,RST SYN')
    expect(@rule.tcp_flags_option).to be_nil
    expect(@rule.to_ipt).to eq '-A FORWARD -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu'
  end

  it "should return valid rule for '-A FORWARD -s 10.5.5.1 -p tcp -m tcp --dport 1024:65535 --tcp-flags FIN,SYN,RST,ACK SYN -m connlimit --connlimit-above 300 --connlimit-mask 32 -j drop-and-log-it'" do
    @rule = FwRuleParser.new('-A FORWARD -s 10.5.5.1 -p tcp -m tcp --dport 1024:65535 --tcp-flags FIN,SYN,RST,ACK SYN -m connlimit --connlimit-above 300 --connlimit-mask 32 -j drop-and-log-it').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('FORWARD')
    expect(@rule.src_ip).to eql('10.5.5.1')
    expect(@rule.dest_ip).to be_nil
    expect(@rule.in_int).to be_nil
    expect(@rule.out_int).to be_nil
    expect(@rule.protocol).to eql('tcp')
    expect(@rule.mod).to be_nil
    expect(@rule.mod_protocol).to eql('tcp')
    expect(@rule.mod_option).to be_nil
    expect(@rule.src_port).to be_nil
    expect(@rule.dest_port).to eql('1024:65535')
    expect(@rule.target).to eql('drop-and-log-it')
    expect(@rule.aft_argument).to be_nil
    expect(@rule.tcp_flags).to eql('FIN,SYN,RST,ACK SYN')
    expect(@rule.tcp_flags_option).to eql('-m connlimit --connlimit-above 300 --connlimit-mask 32')
    expect(@rule.to_ipt).to eq '-A FORWARD -s 10.5.5.1 -p tcp -m tcp --dport 1024:65535 --tcp-flags FIN,SYN,RST,ACK SYN -m connlimit --connlimit-above 300 --connlimit-mask 32 -j drop-and-log-it'
  end

  it "should return valid rule for '-A FORWARD -i eth0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT'" do
    @rule = FwRuleParser.new('-A FORWARD -i eth1 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('FORWARD')
    expect(@rule.src_ip).to be_nil
    expect(@rule.dest_ip).to be_nil
    expect(@rule.in_int).to eql('eth1')
    expect(@rule.out_int).to eql('eth0')
    expect(@rule.protocol).to be_nil
    expect(@rule.mod).to eql('state')
    expect(@rule.mod_option).to eql('--state RELATED,ESTABLISHED')
    expect(@rule.src_port).to be_nil
    expect(@rule.dest_port).to be_nil
    expect(@rule.target).to eql('ACCEPT')
    expect(@rule.aft_argument).to be_nil
    expect(@rule.to_ipt).to eq '-A FORWARD -i eth1 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT'
  end

  it "should return valid rule for '-A FORWARD -d 10.5.5.1 -p tcp -m tcp --dport 1551:1555 -j ACCEPT'" do
    @rule = FwRuleParser.new('-A FORWARD -d 10.5.5.1 -p tcp -m tcp --dport 1551:1555 -j ACCEPT').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('FORWARD')
    expect(@rule.src_ip).to be_nil
    expect(@rule.dest_ip).to eql('10.5.5.1')
    expect(@rule.in_int).to be_nil
    expect(@rule.out_int).to be_nil
    expect(@rule.protocol).to eql('tcp')
    expect(@rule.mod).to be_nil
    expect(@rule.mod_protocol).to eql('tcp')
    expect(@rule.src_port).to be_nil
    expect(@rule.dest_port).to eql('1551:1555')
    expect(@rule.target).to eql('ACCEPT')
    expect(@rule.aft_argument).to be_nil
    expect(@rule.to_ipt).to eq '-A FORWARD -d 10.5.5.1 -p tcp -m tcp --dport 1551:1555 -j ACCEPT'
  end

  it "should return valid rule for '-A FORWARD -j lstat'" do
    @rule = FwRuleParser.new('-A FORWARD -j lstat').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('FORWARD')
    expect(@rule.target).to eql('lstat')
    expect(@rule.to_ipt).to eq '-A FORWARD -j lstat'
  end

  it "should return valid rule for '-A FORWARD -i eth0 -o eth0 -j ACCEPT'" do
    @rule = FwRuleParser.new('-A FORWARD -i eth2 -o eth0 -j ACCEPT').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('FORWARD')
    expect(@rule.in_int).to eql('eth2')
    expect(@rule.out_int).to eql('eth0')
    expect(@rule.target).to eql('ACCEPT')
    expect(@rule.to_ipt).to eq '-A FORWARD -i eth2 -o eth0 -j ACCEPT'
  end
end

describe FwRuleParser, "OUTPUT" do
  it "should return valid rule for '-A OUTPUT -s 10.5.5.200 -o eth0 -p tcp -m state --state NEW,RELATED,ESTABLISHED -m tcp --sport 20 -j ACCEPT'" do
    @rule = FwRuleParser.new('-A OUTPUT -s 10.5.5.200 -o eth0 -p tcp -m state --state NEW,RELATED,ESTABLISHED -m tcp --sport 20 -j ACCEPT').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('OUTPUT')
    expect(@rule.src_ip).to eql('10.5.5.200')
    expect(@rule.dest_ip).to be_nil
    expect(@rule.in_int).to be_nil
    expect(@rule.out_int).to eql('eth0')
    expect(@rule.protocol).to eql('tcp')
    expect(@rule.mod).to eql('state')
    expect(@rule.mod_protocol).to eql('tcp')
    expect(@rule.mod_option).to eql('--state NEW,RELATED,ESTABLISHED')
    expect(@rule.target).to eql('ACCEPT')
    expect(@rule.aft_argument).to be_nil
    expect(@rule.to_ipt).to eq '-A OUTPUT -s 10.5.5.200 -o eth0 -p tcp -m state --state NEW,RELATED,ESTABLISHED -m tcp --sport 20 -j ACCEPT'
  end

  it "should return valid rule for '-A OUTPUT -d 10.0.0.0/255.0.0.0 -o eth0 -j drop-and-log-it'" do
    @rule = FwRuleParser.new('-A OUTPUT -d 10.0.0.0/255.0.0.0 -o eth0 -j drop-and-log-it').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('OUTPUT')
    expect(@rule.dest_ip).to eql('10.0.0.0/255.0.0.0')
    expect(@rule.in_int).to be_nil
    expect(@rule.out_int).to eql('eth0')
    expect(@rule.target).to eql('drop-and-log-it')
    expect(@rule.aft_argument).to be_nil
    expect(@rule.to_ipt).to eq '-A OUTPUT -d 10.0.0.0/255.0.0.0 -o eth0 -j drop-and-log-it'
  end

  it "should return valid rule for '-A OUTPUT -s 10.5.5.200/24 -d 10.0.0.0/255.0.0.0 -o eth0 -j ACCEPT'" do
    @rule = FwRuleParser.new('-A OUTPUT -s 10.5.5.200/24 -d 10.0.0.0/255.0.0.0 -o eth0 -j ACCEPT').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('OUTPUT')
    expect(@rule.src_ip).to eql('10.5.5.200/24')
    expect(@rule.dest_ip).to eql('10.0.0.0/255.0.0.0')
    expect(@rule.in_int).to be_nil
    expect(@rule.out_int).to eql('eth0')
    expect(@rule.target).to eql('ACCEPT')
    expect(@rule.aft_argument).to be_nil
    expect(@rule.to_ipt).to eq '-A OUTPUT -s 10.5.5.200/24 -d 10.0.0.0/255.0.0.0 -o eth0 -j ACCEPT'
  end

  it "should return valid rule for '-A OUTPUT -s 10.5.5.200 -o eth0 -j ACCEPT'" do
    @rule = FwRuleParser.new('-A OUTPUT -s 10.5.5.200 -o eth0 -j ACCEPT').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('OUTPUT')
    expect(@rule.src_ip).to eql('10.5.5.200')
    expect(@rule.dest_ip).to be_nil
    expect(@rule.in_int).to be_nil
    expect(@rule.out_int).to eql('eth0')
    expect(@rule.target).to eql('ACCEPT')
    expect(@rule.aft_argument).to be_nil
    expect(@rule.to_ipt).to eq '-A OUTPUT -s 10.5.5.200 -o eth0 -j ACCEPT'
  end

  it "should return valid rule for '-A OUTPUT -s 10.5.5.100 -d 255.255.255.255 -o eth0 -p tcp -m tcp --sport 67 --dport 68 -j ACCEPT'" do
    @rule = FwRuleParser.new('-A OUTPUT -s 10.5.5.100 -d 255.255.255.255 -o eth0 -p tcp -m tcp --sport 67 --dport 68 -j ACCEPT').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('OUTPUT')
    expect(@rule.src_ip).to eql('10.5.5.100')
    expect(@rule.dest_ip).to eql('255.255.255.255')
    expect(@rule.in_int).to be_nil
    expect(@rule.out_int).to eql('eth0')
    expect(@rule.protocol).to eql('tcp')
    expect(@rule.mod_protocol).to eql('tcp')
    expect(@rule.mod).to be_nil
    expect(@rule.src_port).to eql('67')
    expect(@rule.dest_port).to eql('68')
    expect(@rule.target).to eql('ACCEPT')
    expect(@rule.aft_argument).to be_nil
    expect(@rule.to_ipt).to eq '-A OUTPUT -s 10.5.5.100 -d 255.255.255.255 -o eth0 -p tcp -m tcp --sport 67 --dport 68 -j ACCEPT'
  end
end

describe FwRuleParser, "PREROUTING" do
  it "should return valid rule for '-A PREROUTING -d 10.5.5.200 -i eth0 -p tcp -m tcp --dport 1550 -j DNAT --to-destination 10.5.5.4:1550'" do
    @rule = FwRuleParser.new('-A PREROUTING -d 10.5.5.200 -i eth0 -p tcp -m tcp --dport 1550 -j DNAT --to-destination 10.5.5.4:1550').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('PREROUTING')
    expect(@rule.dest_ip).to eql('10.5.5.200')
    expect(@rule.in_int).to eql('eth0')
    expect(@rule.protocol).to eql('tcp')
    expect(@rule.mod_protocol).to eql('tcp')
    expect(@rule.mod).to be_nil
    expect(@rule.dest_port).to eql('1550')
    expect(@rule.target).to eql('DNAT')
    expect(@rule.aft_option).to eql('--to-destination')
    expect(@rule.aft_argument).to eql('10.5.5.4:1550')
    expect(@rule.to_ipt).to eq '-A PREROUTING -d 10.5.5.200 -i eth0 -p tcp -m tcp --dport 1550 -j DNAT --to-destination 10.5.5.4:1550'
  end

  it "should return valid rule for '-A PREROUTING -d 10.5.5.200 -i eth0 -p udp -m udp --dport 6112:6119 -j DNAT --to-destination 10.5.5.1'" do
    @rule = FwRuleParser.new('-A PREROUTING -d 10.5.5.200 -i eth0 -p udp -m udp --dport 6112:6119 -j DNAT --to-destination 10.5.5.1').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('PREROUTING')
    expect(@rule.dest_ip).to eql('10.5.5.200')
    expect(@rule.in_int).to eql('eth0')
    expect(@rule.protocol).to eql('udp')
    expect(@rule.mod).to be_nil
    expect(@rule.mod_protocol).to eql('udp')
    expect(@rule.target).to eql('DNAT')
    expect(@rule.aft_option).to eql('--to-destination')
    expect(@rule.aft_argument).to eql('10.5.5.1')
    expect(@rule.to_ipt).to eq '-A PREROUTING -d 10.5.5.200 -i eth0 -p udp -m udp --dport 6112:6119 -j DNAT --to-destination 10.5.5.1'
  end
end

describe FwRuleParser, "POSTROUTING" do
  it "should return valid rule for '-A POSTROUTING -s 10.5.5.1 -o eth0 -j SNAT --to-source 10.5.5.200'" do
    @rule = FwRuleParser.new('-A POSTROUTING -s 10.5.5.1 -o eth0 -j SNAT --to-source 10.5.5.200').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('POSTROUTING')
    expect(@rule.src_ip).to eql('10.5.5.1')
    expect(@rule.out_int).to eql('eth0')
    expect(@rule.target).to eql('SNAT')
    expect(@rule.aft_option).to eql('--to-source')
    expect(@rule.aft_argument).to eql('10.5.5.200')
    expect(@rule.to_ipt).to eq '-A POSTROUTING -s 10.5.5.1 -o eth0 -j SNAT --to-source 10.5.5.200'
  end

  it "should return valid rule for '-A POSTROUTING -o eth0 -j MYSHAPER-OUT'" do
    @rule = FwRuleParser.new('-A POSTROUTING -o eth0 -j MYSHAPER-OUT').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('POSTROUTING')
    expect(@rule.out_int).to eql('eth0')
    expect(@rule.target).to eql('MYSHAPER-OUT')
    expect(@rule.aft_argument).to be_nil
    expect(@rule.to_ipt).to eq '-A POSTROUTING -o eth0 -j MYSHAPER-OUT'
  end
end

describe FwRuleParser, "MARK" do
  skip "should return valid rule for '-A MYSHAPER-IN ! -p tcp -j MARK --set-mark 0x1e'" do
    # pending
    @rule = FwRuleParser.new('-t MANGLE -A MYSHAPER-IN ! -p tcp -j MARK --set-mark 0x1e').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('MYSHAPER-IN')
    expect(@rule.protocol).to eql('tcp')
    expect(@rule.mod).to be_nil
    expect(@rule.mod_option).to be_nil
    expect(@rule.mod_protocol).to be_nil
    expect(@rule.target).to eql('MARK')
    expect(@rule.aft_option).to eql('--set-mark')
    expect(@rule.aft_argument).to eql('0x1e')
    expect(@rule.to_ipt).to eq '-t MANGLE -A MYSHAPER-IN ! -p tcp -j MARK --set-mark 0x1e'
  end

  it "should return valid rule for '-A MYSHAPER-IN -m mark --mark 0x0 -j MARK --set-mark 0x23'" do
    @rule = FwRuleParser.new('-A MYSHAPER-IN -m mark --mark 0x0 -j MARK --set-mark 0x23').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('MYSHAPER-IN')
    expect(@rule.protocol).to be_nil
    expect(@rule.mod).to eql('mark')
    expect(@rule.mod_option).to eql('--mark 0x0')
    expect(@rule.mod_protocol).to be_nil
    expect(@rule.target).to eql('MARK')
    expect(@rule.aft_option).to eql('--set-mark')
    expect(@rule.aft_argument).to eql('0x23')
    expect(@rule.to_ipt).to eq '-A MYSHAPER-IN -m mark --mark 0x0 -j MARK --set-mark 0x23'
  end

  it "should return valid rule for '-A MYSHAPER-IN -j IMQ --todev 0'" do
    @rule = FwRuleParser.new('-A MYSHAPER-IN -j IMQ --todev 0').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('MYSHAPER-IN')
    expect(@rule.protocol).to be_nil
    expect(@rule.mod).to be_nil
    expect(@rule.mod_option).to be_nil
    expect(@rule.mod_protocol).to be_nil
    expect(@rule.target).to eql('IMQ')
    expect(@rule.aft_option).to eql('--todev')
    expect(@rule.aft_argument).to eql('0')
    expect(@rule.to_ipt).to eq '-A MYSHAPER-IN -j IMQ --todev 0'
  end

  it "should return valid rule for '-A MYSHAPER-OUT -m layer7 --l7proto ftp -j MARK --set-mark 0x18'" do
    @rule = FwRuleParser.new('-A MYSHAPER-OUT -m layer7 --l7proto ftp -j MARK --set-mark 0x18').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('MYSHAPER-OUT')
    expect(@rule.protocol).to be_nil
    expect(@rule.mod).to eql('layer7')
    expect(@rule.mod_option).to eql('--l7proto ftp')
    expect(@rule.mod_protocol).to be_nil
    expect(@rule.target).to eql('MARK')
    expect(@rule.aft_option).to eql('--set-mark')
    expect(@rule.aft_argument).to eql('0x18')
    expect(@rule.to_ipt).to eq '-A MYSHAPER-OUT -m layer7 --l7proto ftp -j MARK --set-mark 0x18'
  end

  it "should return valid rule for '-A MYSHAPER-IN -p tcp -m length --length 0:64 -j MARK --set-mark 0x1f'" do
    @rule = FwRuleParser.new('-A MYSHAPER-IN -p tcp -m length --length 0:64 -j MARK --set-mark 0x1f').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('MYSHAPER-IN')
    expect(@rule.protocol).to eql('tcp')
    expect(@rule.mod).to eql('length')
    expect(@rule.mod_option).to eql('--length 0:64')
    expect(@rule.mod_protocol).to be_nil
    expect(@rule.target).to eql('MARK')
    expect(@rule.aft_option).to eql('--set-mark')
    expect(@rule.aft_argument).to eql('0x1f')
    expect(@rule.to_ipt).to eq '-A MYSHAPER-IN -p tcp -m length --length 0:64 -j MARK --set-mark 0x1f'
  end

  it "should return valid rule for '-A MYSHAPER-IN -p tcp -m tcp --dport 22 -j MARK --set-mark 0x20'" do
    @rule = FwRuleParser.new('-A MYSHAPER-IN -p tcp -m tcp --dport 22 -j MARK --set-mark 0x20').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('MYSHAPER-IN')
    expect(@rule.protocol).to eql('tcp')
    expect(@rule.mod).to be_nil
    expect(@rule.mod_protocol).to eql('tcp')
    expect(@rule.target).to eql('MARK')
    expect(@rule.aft_option).to eql('--set-mark')
    expect(@rule.aft_argument).to eql('0x20')
    expect(@rule.to_ipt).to eq '-A MYSHAPER-IN -p tcp -m tcp --dport 22 -j MARK --set-mark 0x20'
  end
end

describe FwRuleParser, "CUSTOM" do
  it "should return valid rule for '-A lstat -d 10.5.5.46 -m state --state RELATED,ESTABLISHED -j ACCEPT'" do
    @rule = FwRuleParser.new('-A lstat -d 10.5.5.46 -m state --state RELATED,ESTABLISHED -j ACCEPT').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('lstat')
    expect(@rule.dest_ip).to eql('10.5.5.46')
    expect(@rule.mod).to eql('state')
    expect(@rule.mod_option).to eql('--state RELATED,ESTABLISHED')
    expect(@rule.target).to eql('ACCEPT')
    expect(@rule.aft_argument).to be_nil
    expect(@rule.to_ipt).to eq '-A lstat -d 10.5.5.46 -m state --state RELATED,ESTABLISHED -j ACCEPT'
  end

  it "should return valid rule for '-A lstat -s 10.5.5.47 -i eth0 -j ACCEPT'" do
    @rule = FwRuleParser.new('-A lstat -s 10.5.5.47 -i eth0 -j ACCEPT').parse
    expect(@rule.cmd).to eql('A')
    expect(@rule.chain_name).to eql('lstat')
    expect(@rule.src_ip).to eql('10.5.5.47')
    expect(@rule.in_int).to eql('eth0')
    expect(@rule.target).to eql('ACCEPT')
    expect(@rule.aft_argument).to be_nil
    expect(@rule.to_ipt).to eq '-A lstat -s 10.5.5.47 -i eth0 -j ACCEPT'
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
