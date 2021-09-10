from .ploi import PLOI, IOBIG
from .hpn import HPN, SDBIG

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