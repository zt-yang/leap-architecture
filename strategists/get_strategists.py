from .ploi import PLOI, IOBIG
from .hpn import HPN, SDBIG
from .post_strategists import Concat, TryAgain

def get_strategists(args_strategists='', verbose=False):

    strategists = []

    for name in args_strategists.split(','):

        name = name.lower()
        
        if name == 'ploi': 
            strategists.append( PLIO() )
        
        elif name == 'iobig': 
            strategists.append( IOBIG() ) 
        
        elif name == 'hpn': 
            strategists.append( HPN() )
        
        elif name == 'sdbig': 
            strategists.append( SDBIG() )

        elif name != '': 
            print('unknown strategist', name)

    return strategists


def get_post_strategists(pre_strategists='', verbose=False):

    strategists = []

    for name in pre_strategists.split(','):

        if name == 'sdbig':
            strategists.append( Concat( reverse=True ) )
            strategists.append( TryAgain( trials=12 ) )

        # elif name != '': 
        #     print('unused strategist', name)

    return strategists
