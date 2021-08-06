"""General interface for a planner.
"""

import abc
import numpy as np


class Planner:
    """An abstract planner for Leap
    """
    def __init__(self):
        self._statistics = {}

    @abc.abstractmethod
    def __call__(self, domain_file, problem_file, timeout=10):
        """Takes in a PDDL domain and problem file. Returns a plan.
        """
        raise NotImplementedError("Override me!")

    def reset_statistics(self):
        """Reset the internal statistics dictionary.
        """
        self._statistics = {}

    def get_statistics(self):
        """Get the internal statistics dictionary.
        """
        return self._statistics