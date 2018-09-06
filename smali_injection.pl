#!/usr/bin/env perl

chomp $_; s/\$/\\\$/g;
if(/.*\.smali$/){
	$text = `cat $_`;
	$ret = split_smali($text,$_);
	print "change $_\n";
	s/\\//g;
	open my $fh, ">", $_;
	print $fh $ret;
	close $fh;
}

sub split_smali{
	my ($text, $dir) = @_;
	my @arr = split "\n",$text;
	my $met_flag = -1;
	my ($header,$method);
	my @arr_met,@new_met;

	foreach $line (@arr){
		$met_flag = 1 if($line =~ /^\.method/);
		if($met_flag == 1){
			$method .= $line."\n";
		}	
		elsif($met_flag == -1){
			$header .= $line."\n";
		}	
		if($line =~ /^\.end method/){
			$met_flag = 0;
			push @arr_met, $method;
			$method = "";
		}
	}
	my $new_smali .= $header;
	my $cnt = 0;
	foreach (@arr_met){
		my $tmp = injection_smali($_,$dir,$cnt);
		$new_smali .= $tmp;
		$cnt++;
	}
	return $new_smali;
}

sub injection_smali{
	my $old_method = shift;
	my $file_name = shift;
	my $invoke_count = shift;
	my $count = 0;
	my $code;
	if($old_method =~ /(locals) (\d)/){
		$count =  $2 + 2;
	}
	my $v1 = $count -2;
	my $v2 = $count -1;
	$code .= "\n    const-string v" . $v1 . ', "smali name : '. $file_name . "\"\n";
	$code .= "    const-string v" . $v2 .", \"method count  : ".$invoke_count."\"\n";
	$code .= "    invoke-static {v" .$v1 .", v".$v2 ."}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)V\n\n    invoke-";

	$old_method =~ s/invoke-/$code/g;
	$old_method =~ s/(locals) (\d)/locals $count/g;
	return $old_method;
}
