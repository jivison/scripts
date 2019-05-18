import requests
import html
import random
import os, sys

# Sample API call
# https://opentdb.com/api.php?amount=10&category=23&difficulty=easy&type=multiple

amount = int(sys.argv[1][0])
category = None


def get_questions(params):
    url_string = u"https://opentdb.com/api.php"

    response = requests.get(
        url_string,
        params=params
    )

    if response.status_code == 200:
        return response.json()
    else:
        print(f"An error occured, status code: {response.status_code}")
        return None

def end_screen(amount_correct):
    print(f"You scored {amount_correct}/{amount} (%{round(amount_correct/amount * 100)})")

def ask(response):
    
    amount_correct = 0    

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

            try:
                guess = int(guess)
            except Exception as e:
                guess = -1

            

            if guess <= len(all_answers) and guess >= 0:
                print("Correct!" if (all_answers[guess] == answers["correct"]) else f"Wrong, correct answer: {answers['correct']}")

                if (all_answers[guess] == answers["correct"]):
                    amount_correct += 1

                input("\nEnter anything to continue...")
                break
            
            else:
                prompt = "invalid answer"

    end_screen(amount_correct)


    


        
        

ask(get_questions({"amount" : amount}))


