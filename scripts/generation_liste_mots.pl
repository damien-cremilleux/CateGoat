#!/usr/bin/perl

# Generation de la liste de l'ensembles des mots présents dans les textes, à l'exception des stopwords

my $listWords = "listWords.txt";

my %allWords;

my @stopWords = ("a","i","i\'d","\'","at","about", "above", "above", "across", "after", "afterwards", "again", "against", "all", "almost", "alone", "along", "already", "also","although","always","am","among", "amongst", "amoungst", "amount",  "an", "and", "another", "any","anyhow","anyone","anything","anyway", "anywhere", "are", "around", "as",  "at", "back","be","became", "because","become","becomes", "becoming", "been", "before", "beforehand", "behind", "being", "below", "beside", "besides", "between", "beyond", "bill", "both", "bottom","but", "by", "call", "can", "cannot", "cant", "co", "con", "could", "couldnt", "cry", "de", "describe", "detail", "do", "done", "down", "due", "during", "each", "eg", "eight", "either", "eleven","else", "elsewhere", "empty", "enough", "etc", "even", "ever", "every", "everyone", "everything", "everywhere", "except", "few", "fifteen", "fify", "fill", "find", "fire", "first", "five", "for", "former", "formerly", "forty", "found", "four", "from", "front", "full", "further", "get", "give", "go", "had", "has", "hasnt", "have", "he", "hence", "her", "here", "hereafter", "hereby", "herein", "hereupon", "hers", "herself", "him", "himself", "his", "how", "however", "hundred", "ie", "if", "in", "inc", "indeed", "interest", "into", "is", "it", "its", "itself", "keep", "last", "latter", "latterly", "least", "less", "ltd", "made", "many", "may", "me", "meanwhile", "might", "mill", "mine", "more", "moreover", "most", "mostly", "move", "much", "must", "my", "myself", "name", "namely", "neither", "never", "nevertheless", "next", "nine", "no", "nobody", "none", "noone", "nor", "not", "nothing", "now", "nowhere", "of", "off", "often", "on", "once", "one", "only", "onto", "or", "other", "others", "otherwise", "our", "ours", "ourselves", "out", "over", "own","part", "per", "perhaps", "please", "put", "rather", "re", "same", "see", "seem", "seemed", "seeming", "seems", "serious", "several", "she", "should", "show", "side", "since", "sincere", "six", "sixty", "so", "some", "somehow", "someone", "something", "sometime", "sometimes", "somewhere", "still", "such", "system", "take", "ten", "than", "that", "the", "their", "them", "themselves", "then", "thence", "there", "thereafter", "thereby", "therefore", "therein", "thereupon", "these", "they", "thickv", "thin", "third", "this", "those", "though", "three", "through", "throughout", "thru", "thus", "to", "together", "too", "top", "toward", "towards", "twelve", "twenty", "two", "un", "under", "until", "up", "upon", "us", "very", "via", "was", "we", "well", "were", "what", "whatever", "when", "whence", "whenever", "where", "whereafter", "whereas", "whereby", "wherein", "whereupon", "wherever", "whether", "which", "while", "whither", "who", "whoever", "whole", "whom", "whose", "why", "will", "with", "within", "without", "would", "yet", "you", "your", "yours", "yourself", "yourselves", "the", "&amp", "&gt", "&lt", "&#", "reuter", " ");

open(WORDS, ">$listWords") or die "Unable to open file $listWords\n";

my $phrase;
my @texts;

foreach my $f (@ARGV)
{
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

		#if ($l =~ /<REUTERS TOPICS=(.*?) LEWISSPLIT=(.*?) CGISPLIT=(.*?) OLDID=(.*)>/)
		#{
			#print WORDS "TOPICS : $1\n";
			#print WORDS "LEWIS : $2\n";
			#print WORDS "CGI : $3\n";
		#}

		#if ($l =~ /<TOPICS>(.*?)<\/TOPICS>/)
		#{
			#my $tmp = $1;
			#$tmp =~ s/<D>//g;
			#$tmp =~ s/<\/D>/,/g;
			#chop($tmp);
			#print WORDS "TOPICS : $tmp\n";
		#}

		#if ($l =~ /<TITLE>(.*?)<\/TITLE>/)
		#{
			#print WORDS "TITLE : $1\n\n";
		#}

		if ($l =~ /<BODY>(.*)<\/BODY>/)
		{	
			$tmp = $1;
			$tmp = lc ($tmp);	
			$tmp =~ s/##/\n/g;
			$tmp =~ s/[.,;:\+\-\*=\$"'\/?!()[\]<>^@]/ /g;
			$tmp =~ s/\d+//g;

			my @words = split(/\s+/,$tmp);

			foreach my $p (@words)
			{
				$allWords{$p} = 0;
			}
		}
	
		#print WORDS "*****************************************************************************************\n\n";
	}

    close FILE;
}
	
foreach my $k (sort keys(%allWords)) {
	if (!grep /$k/, @stopWords)
	{
		print WORDS "$k\n";
		#$allWords{$k}
	}
}

close WORDS;
