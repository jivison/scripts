#! /usr/bin/python3

import requests
import html
import random
import os, sys

arg_whitelist = ["amount", "category", "difficulty", "type"]

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

# Sample API call
# https://opentdb.com/api.php?amount=10&category=23&difficulty=easy&type=multiple

class TriviaError(Exception):
    def __init__(self, context, **kwargs):
        if context == "bad_argument":
            super().__init__(f"play trivia: {bcolors.FAIL}bad argument '{kwargs['argument']}'{bcolors.ENDC}")
        elif context == "bad_argument_value":
            super().__init__(f"play trivia: {bcolors.FAIL}bad argument value '{kwargs['value']}' for argument '{kwargs['argument']}'{bcolors.ENDC}")
        elif context == "bad_response":
            super().__init__(f"play trivia: {bcolors.FAIL}bad response '{kwargs['code']}{bcolors.ENDC}")
        elif context == "internet":
            super().__init__(f"play trivia: {bcolors.OKBLUE}bad connection, check that you are connected to the internet{bcolors.ENDC}")

def vetArgValue(arg, value):
    try:
        if arg == "amount":
            if int(value) < 1 or int(value) > 25:
                raise Exception
        elif arg == "category":
            if int(value) < 9 or int(value) > 32:
                raise Exception
        elif arg == "difficulty":
            if value not in ["easy", "medium", "hard"]:
                raise Exception
        elif arg == "type":
            if value not in ["boolean", "multiple"]:
                raise Exception
                    
    except Exception:
        raise TriviaError("bad_argument_value", value=value, argument=arg)
        return False
    
    else:
        return True

def get_questions(params):
    url_string = u"https://opentdb.com/api.php"

    try:
        response = requests.get(
            url_string,
            params=params
        )
    except Exception:
        raise TriviaError("internet")

    if response.status_code == 200:
        return response.json()
    else:
        print(f"An error occured, status code: {response.status_code}")
        raise TriviaError("bad_response", code=response.status_code)
        return None

def end_screen(scoreArray):
    print(f"You scored {sum(scoreArray)}/{len(scoreArray)} (%{round(sum(scoreArray)/len(scoreArray) * 100)})")

def ask(response):
    
    score = []    

    for i in range(len(response["results"])):

        result = response["results"][i]

        question = html.unescape(result["question"])

        answers = {
            "correct" : html.unescape(result["correct_answer"]),
            "incorrect" : [html.unescape(answer) for answer in result["incorrect_answers"]],
        }

        all_answers = [answers["correct"]] + answers["incorrect"]
        random.shuffle(all_answers)
        
        prompt = "?"

        while True:
            os.system("clear")


            print(question)

            for answer_i in range(len(all_answers)):
                print(f"    {answer_i}. {all_answers[answer_i]}")
            
            guess = input(f"{prompt}> ")

            if guess == "quit" or guess == "q":
                quit()

            try:
                guess = int(guess)
            except Exception as e:
                guess = -1

            

            if guess <= len(all_answers) and guess >= 0:
                print("Correct!" if (all_answers[guess] == answers["correct"]) else f"Wrong, correct answer: {answers['correct']}")

                if (all_answers[guess] == answers["correct"]):
                    score.append(1)
                else:
                    score.append(0)

                input("\nEnter anything to continue...")
                break
            
            else:
                prompt = "invalid answer"

    end_screen(score)




def printHelp():
    print("""
play trivia help
================

trivia is a play which uses opentdb's trivia database to ask some trivia questions

enter the index of the answer you wish to give when the question appears
enter 'q' or 'quit' to end it without scoring


trivia arguments are passed like Python kwargs, like so:

play trivia <argument>=<value>


arguments:

    amount...............................the number of questions the API returns, restricted between 1 and 25, defaults to 5

    category.............................what category of questions the API returns, restricted between 9 and 32

    difficulty...........................what difficulty of questions the API returns, restricted to either 'easy', 'medium'

    type.................................can either be multiple (multiple choice) or boolean (true/false)





""")