//
//  main.cpp
//  Counter
//
//  Created by COZ Samuel on 10/04/2014.
//  Copyright (c) 2014 COZ Samuel. All rights reserved.
//

#include <iostream>
#include <map> 
#include <fstream> 
#include <string>
#include <vector>

using namespace std;

#define END_DELIMITER "$$$"

static unsigned int article_count = 1;

/**
* String to char*  :)
*/
const char* str2char(string in)
{
	return in.c_str();
}

/**
* Creation du fichier resultat (useless func :))
*/
void creer_fichier(string f)
{
	const char* file = str2char(f);
	ofstream fichier(file, ios::out | ios::trunc);  // ouverture en écriture avec effacement du fichier ouvert

	if(fichier)
	{
		// fichier << "ARTICLE numero " << article_count << " \n\n";
		// article_count++;

		fichier.close();
	}
}

/**
* Ecriture du fichier resultat
*/
/*
void ecrire_fichier(string f, const map<string, unsigned int> map)
{
	const char* file = str2char(f); 
	ofstream fichier(file, ios::out | ios::app);
	std::map<string, unsigned int>::const_iterator itr;

	if(fichier)
	{
		for (itr = map.begin(); itr != map.end(); ++itr)
			fichier << itr->first << ": " << itr->second << endl;
	}
	else
	{
		cerr << "Impossible d'ouvrir le fichier !" << endl;
	}

	fichier << "\nARTICLE numero " << article_count << " \n\n";
	article_count++;

	fichier.close();
}
*/

/**
* Ecriture du fichier resultat
*/
void ecrire_fichier(string f, const map<string, unsigned int> wordsCount, const vector<string> topic, const map<string, unsigned int> mapTopics)
{
  const char* file = str2char(f); 
  ofstream fichier(file, ios::out | ios::app);

  if(fichier)
  {
		for(int numTopic = 0; numTopic < topic.size(); numTopic++)
		{
  			int numWord = 1;

			fichier << mapTopics.find(topic[numTopic])->second << " ";

		    for (map<string, unsigned int>::const_iterator itrWords = wordsCount.begin(); itrWords != wordsCount.end(); ++itrWords)
		    {
		      fichier << numWord << ":" << itrWords->second << " ";
		      numWord++;
		    }

		    if (numTopic < (topic.size() - 1))
		    	fichier << "\n";
		}
		
		fichier << "\n";
  }
  else
  {
    cerr << "Impossible d'ouvrir le fichier !" << endl;
  }

  // fichier << "\nARTICLE numero " << article_count << " \n\n";
  // article_count++;

  fichier.close();

}

/**
* ...main
*/

int main(int argc, const char * argv[])
{
	/**
	* Creation de la map contenant tous les topics
	*/

	map<string, unsigned int> mapTopics;
	map<string, unsigned int>::iterator iterTopics;

	ifstream fileStreamTopics("alltopics.txt");

	if (fileStreamTopics.is_open())
	{
		int num = 1;
		while (fileStreamTopics.good())
		{
	    string word;
			fileStreamTopics >> word;

			mapTopics[word] = num;
			num++;
		}	
	}

	fileStreamTopics.close();

	/**
	* Generation de la liste de tous les mots du train
	*/

	int test = 0;

	static const char* fileName = argv[1];
	static const char* fRes = argv[2];
	static const char* fileVect;

	// Choix entre train ou test
	if(argc > 3) {
		test = 1;
		fileVect = argv[3];
	}

	//Creer notre fichier resultat
	creer_fichier(fRes);


	// PREMIERE LECTURE

	// Map qui contiendra MOT : NBOCC
	map<string, unsigned int> wordsCount;
	// iterateur
	map<string, unsigned int>::iterator iter;

	// Commence la lecture du fichier
	ifstream fileStream(fileName);

	//DONNEES ENTRAINEMENT
	if(!test) {  
		// Verifie si on a ouvert le fichier
		if (fileStream.is_open()) {
			int in_cat = 0;
			while (fileStream.good())
			{
				// Store le prochain mot dans une variable
				string word;
				fileStream >> word;

				//	cout << word << "\n";

				//On ne lit pas les categories
				if (word == "<TOPICS>") {
					in_cat = 1;
				}

				if(!in_cat) {
					//Regarde si deja présent
					if (wordsCount.find(word) == wordsCount.end() && word != END_DELIMITER) // Si on rencontre le mot pour la premiere fois
						wordsCount[word] = 0; // on l'ajoute à la table
				}

				//On ne lit pas les categories
				if (word == "</TOPICS>") {
					in_cat = 0;
				}    
			}
		}
		else  
		{
			cerr << "Ouverture Impossible." << endl;
			return 1;
		}

		/**
		* Creation du fichier vecteur contenant tous les mots du train
		*/

		const char* file = str2char("Vecteur.txt");
		ofstream fichier(file, ios::out | ios::trunc);

		for(iter = wordsCount.begin(); iter != wordsCount.end(); iter++)
			fichier <<  iter->first << "\n";

		fichier.close();
	}

	fileStream.close();

	wordsCount.clear();

	/**
	* On remplit wordsCount avec la liste des mots du train
	*/

	ifstream fileStreamVect("Vecteur.txt");

	if (fileStreamVect.is_open()) {
		while (fileStreamVect.good())
		{
			// Store le prochain mot dans une variable
			string word;
			fileStreamVect >> word;

			//On ne lit pas les categories
			wordsCount[word] = 0;
		}
	}
	fileStreamVect.close();

	/**
	* Generation du fichier resultat
	*/

	// On revient au debut 
	fileStream.open(fileName);

	// Verifie si on a ouvert le fichier
	if (fileStream.is_open()) {
		int in_cat = 0;
    	std::vector<string> topic;     

		while (fileStream.good())
		{
			string word;
			fileStream >> word;

			if (word == "<TOPICS>") {
				in_cat = 1;
			}

			if(!in_cat) {
				if (word == END_DELIMITER){
					ecrire_fichier(fRes, wordsCount, topic, mapTopics);
					for(iter = wordsCount.begin(); iter != wordsCount.end(); iter++)
						iter->second = 0;
         			topic.clear();
				} 

				if (wordsCount.find(word) != wordsCount.end())
					wordsCount[word]++; // Incrementage
			}
  		else {
        if(word != "<TOPICS>" && word != "</TOPICS>")
          	topic.push_back(word);
  		}

			if (word == "</TOPICS>") {
				in_cat = 0;
			}
		}
	}
	else  
	{
		cerr << "Ouverture Impossible." << endl;
		return 1;
	}

	return 0;
}