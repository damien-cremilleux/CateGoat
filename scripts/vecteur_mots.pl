#!/usr/bin/perl

my $data = "data.txt";
my $words = "listWords.txt";

open(DATA, ">$data") or die "Unable to open file $data\n";
open(WORDS, "<$words") or die "Unable to open file $words\n";

my %scalar;

while ($w = <WORDS>)
{
	$scalar{$w} = 0;
}

sort keys(%scalar);

my $numFile = -1;
my $numText = 0;

foreach my $f (@ARGV)
{
	foreach my $k (%scalar)
	{
		$scalar{$k} = 0;
	}

	$numFile++;

	print DATA "**************************************** File reut2-00$numFile.sgm ****************************************\n\n";
	print DATA "\n";

	open (FILE, "<$f");

	while ($line = <FILE>)
	{
		$line =~ s/\n/##/;
		if ($line !~ /<!DOCTYPE.*>/)
		{
			if($line !~ /<\/REUTERS>/)
			{
				my $tmp = $phrase;
				$phrase = join('', $tmp, $line);
			}
			else
			{
				my $tmp = $phrase;
				$phrase = join('', $tmp, "</REUTERS>\n");
				push @texts, $phrase;
				$phrase = "";
			}
		}
	}

	foreach my $l (@texts)
	{
		if ($l =~ /<BODY>(.*)<\/BODY>/)
		{	
			$numText++;

			$tmp = $1;
			$tmp = lc ($tmp);	
			$tmp =~ s/##/\n/g;
			$tmp =~ s/[.,;:\+\-\*=\$"'\/?!()[\]<>^@]/ /g;
			$tmp =~ s/\d+//g;

			my @words = split(/\s+/,$tmp);

			foreach my $p (@words)
			{
				if (grep /$p/, keys %scalar)
				{
					$scalar{$p}++;
				}
			}
		}

		print DATA "Texte N°$numText\n";

		print DATA "(";

		my $nul = 0;

		foreach my $k (%scalar)
		{
			if ($nul ne 0)
			{
				print DATA ",";
				print DATA "$scalar{$k}";
			}
			else
			{
				print DATA "$scalar{$k}";
				$nul = 1;
			}
		}

		print DATA ")\n\n";

	}

    close FILE;
}
