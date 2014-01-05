ERLC=/usr/bin/erlc
ERLCFLAGS=-o
SRCDIR=./src
BEAMDIR=/usr/lib/yaws/custom/ebin

all:
	@ $(ERLC) $(ERLCFLAGS) $(BEAMDIR) $(SRCDIR)/*.erl ;
