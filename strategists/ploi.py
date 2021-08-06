""" Example interface for pre-strategist PLOI.
"""

## import ....
import abc

class PLOI(PreStrategist):
    """ Reduces the universe/ number of objects of a problem
    """

    def __call__(self, domain_file, problem_file, timeout=10):
        """ Takes in a PDDL domain and problem file. 
            Returns a set of sequence of subproblems.
                [ [ (domain.pddl, problem.pddl) ] ]
                e.g. PLOI may sample multiple minimum object sets 
                    with incremental importance score threshold
        """

        ## objects = get_objects()
        ## make the problem file / return the objects

        raise NotImplementedError("Override me!")
