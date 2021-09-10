"""General interface for a pre- and post-strategists.
"""

import abc

class Strategist:
    """An abstract strategist for Leap
    """

    name = 'unknown'

    def __init__(self):
        """ initialize with the orginal domain and problem files """ 
        pass

    def init_task(self, task):
        self.task_original = task
        


class PreStrategist(Strategist):
    """An abstract pre-strategist for Leap
    """

    @abc.abstractmethod
    def __call__(self, domain_file, problem_file, expdir, timeout=10):
        """ Takes in a PDDL domain and problem file. 
            Returns a set of sequence of subproblems.
                [ [ (domain.pddl, problem.pddl) ] ]
                e.g. PLOI may sample multiple minimum object sets 
                    with incremental importance score threshold
        """
        raise NotImplementedError("Override me!")


class PostStrategist(Strategist):
    """An abstract post-strategist for Leap
    """

    @abc.abstractmethod
    def __call__(self, outputs, expdir, trials=5, timeout=10):
        """ Takes in outputs from planner
            Returns refined outputs 
        """
        raise NotImplementedError("Override me!")

