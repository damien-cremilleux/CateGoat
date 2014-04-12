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
//#include <cstdlib>
//#include <stdio.h>
#include <iostream>

//#include <cstring>
using namespace std;

#define END_DELIMITER "$$$"

static unsigned int article_count = 1;

//String to char*  :)
const char* str2char(string in)
{

  // char *res=new char[in.size()+1];
  // res[in.size()]=0;
  // memcpy(res,in.c_str(),in.size());
  return in.c_str();
}

void creer_fichier(string f)
{

  const char* file = str2char(f);
  ofstream fichier(file, ios::out | ios::trunc);  // ouverture en écriture avec effacement du fichier ouvert
    
  if(fichier)
    {
      fichier << "ARTICLE numero " << article_count << " \n\n";
      article_count++;
        
      fichier.close();
    }
}



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
/*
  ofstream fichier("/Users/cozsamuel/Documents/Programmation/COURS/COURS1/Revision/SDLTEST/Counter/Counter/Res.txt", ios::out | ios::trunc);  // ouverture en écriture avec effacement du fichier ouvert
 
 
  if(fichier)
  {
 
  map<string, unsigned int>::const_iterator itr;
  for (itr = wordsCount.begin(); itr != wordsCount.end(); ++itr)
  fichier << itr->first << ": " << itr->second << endl;
 
 
  fichier.close();
  }
  else
  cerr << "Impossible d'ouvrir le fichier !" << endl;
 
*/



int main(int argc, const char * argv[])
{

  //Fichier à compter
  // static const char* fileName = "/Users/cozsamuel/Documents/Programmation/COURS/COURS1/Revision/SDLTEST/Counter/Counter/README.txt";
    
  //   //Fichier résultat
  //   static const char* fRes = "/Users/cozsamuel/Documents/Programmation/COURS/COURS1/Revision/SDLTEST/Counter/Counter/res.txt";
  
  static const char* fileName = argv[1];
  static const char* fRes = argv[2];
  //Creer notre fichier resultat
  creer_fichier(fRes);
    

  // PERMIERE LECTURE

  // Map qui contiendra   MOT : NBOCC
  map<string, unsigned int> wordsCount;
  // ierateur
  map<string, unsigned int>::iterator iter;
  
  // Commence la lecture du fichier
  ifstream fileStream(fileName);
    
  // Verifie si on a ouvert le fichier
  if (fileStream.is_open())
    while (fileStream.good())
      {
	// Store le prochain mot dans une variable
	string word;
	fileStream >> word;
                           
	//Regarde si deja présent
	if (wordsCount.find(word) == wordsCount.end()) // Si on rencontre le mot pour la premiere fois
	  wordsCount[word] = 0; // on l'ajoute à la table
      }
  else  
    {
      cerr << "Ouverture Impossible." << endl;
      return 1;
    }


  // On revient au debut
  fileStream.close();
  fileStream.open(fileName);

  //  fseek(fileName,0,SEEK_SET);
        
  // Verifie si on a ouvert le fichier
  if (fileStream.is_open())
    while (fileStream.good())
      {
	// Store le prochain mot dans une variable
	string word;
	fileStream >> word;
	                
	//Si c'est un nouvel article on effacera la map et tout et tout
	if (word == END_DELIMITER){
	  ecrire_fichier(fRes, wordsCount);
	  for(iter = wordsCount.begin(); iter != wordsCount.end(); iter++)
	    iter->second = 0;
	}
                    
	//Regarde si deja présent
	if (wordsCount.find(word) == wordsCount.end()) // Si on rencontre le mot pour la premiere fois
	  wordsCount[word] = 1; // Initialisation à 1
	else //Si deja preésent
	  wordsCount[word]++; // Incrementage
      }
  else  
    {
      cerr << "Ouverture Impossible." << endl;
      return 1;
    }

        

    
  return 0;
}


