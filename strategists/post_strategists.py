import abc
from time import time
from.strategist import PostStrategist


class Concat(PostStrategist):
    """ Concatenate outputs into a single plan, return False if any plan failed """

    name = 'Concat'
    
    def __init__(self, reverse=False):
        self.reverse = reverse

    def __call__(self, outputs, expdir):
        if self.reverse: outputs.reverse()
        if False not in outputs:
            outputs = [[a for a in output] for output in outputs]
        else:
            outputs = False
        return outputs, 0


class TryAgain(PostStrategist):
    """ Separate Domains Based on Influence Graph """

    name = 'TryAgain'
    
    def __init__(self, trials=5):
        self.trials_original = trials
        self.trials = trials


    def __call__(self, outputs, expdir):

        start = time()
        self.trials -= 1

        if not outputs:

            if self.trials > 0:
                leap = self.leap
                if self.verbose:
                    print(f'\n\n... running Post-Strategist TryAgain (remaining {self.trials} times)')

                tasks = leap.run_pre_strategists(leap.task, expdir)

                ## run the planner on each subtask
                outputs = leap.run_planner(tasks, expdir)

                ## refines the subplans, may involve solving the problem again
                outputs = leap.run_post_strategists(outputs, expdir)

            else:
                if self.verbose:
                    print(f'TryAgain declared failure after {self.trials_original} trials')

        return outputs, time() - start
