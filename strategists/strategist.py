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
        self._ori_domain = task[0]
        self._ori_problem = task[1]
        self.reset()

    def reset(self):
        self._domain = self._ori_domain
        self._problem = self._ori_problem



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
    def __call__(self, plan, domain_file, problem_file, timeout=10):
        """ Takes in a plan, along with a PDDL domain and problem file. 
            Returns 
                a refined plan 
                or 
                None, which triggers replanning from original problem
        """
        raise NotImplementedError("Override me!")

