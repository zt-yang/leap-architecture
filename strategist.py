"""General interface for a pre- and post-strategists.
"""

import abc

class Strategist:
    """An abstract strategist for Leap
    """
    def __init__(self, name, domain_file, problem_file):
        self._name = None
        self._ori_domain = domain_file
        self._ori_problem = problem_file
        self.reset()

    def reset():
        self._domain = self._ori_domain
        self._problem = self._ori_problem


class PreStrategist(Strategist):
    """An abstract pre-strategist for Leap
    """

    @abc.abstractmethod
    def __call__(self, domain_file, problem_file, timeout=10):
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