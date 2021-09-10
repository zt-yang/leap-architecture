import argparse

from cogmen.leap import LEAP
from strategists.get_strategists import get_strategists, get_post_strategists
from planners.planner import get_planner

parser = argparse.ArgumentParser()
parser.add_argument(dest="domain")
parser.add_argument(dest="problem")
parser.add_argument('-p', dest="planner", type=str, default='fd')
parser.add_argument('-po', dest="planner_option", type=str, default="lama-first")
parser.add_argument('-o', dest="use_objects", type=str, default=None)
parser.add_argument('-s', dest="strategists", type=str, default='')
parser.add_argument('-v', dest="verbose", type=int, default=1)
parser.add_argument('-e', dest="exp_dir", type=str, default='experiments')
parser.add_argument('-t', dest="timeout", type=int, default=10)
args = parser.parse_args()


## python main.py grocery_costs.pddl shop_veggies.pddl -o obj_grocery_costs.pddl -v 1 -e 'experiments/domain_merge'
if __name__ == "__main__":

    leap = LEAP( expdir = args.exp_dir, verbose = args.verbose )
    
    leap.init_planner( 
        get_planner( args.planner, args.planner_option, args.timeout ) 
    )

    leap.init_pre_strategists( 
        get_strategists( args.strategists ) 
    )

    leap.init_post_strategists( 
        get_post_strategists( pre_strategists=args.strategists ) 
    )

    plan = leap( args.domain, args.problem, args.use_objects )