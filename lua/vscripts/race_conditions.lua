vim.cmd([[
	inoreabbrev Ydate <C-R>=strftime("%d-%b-%Y")<CR>
	inoreabbrev rev: <c-r>=printf(&commentstring, ' REVISIT '.$USER.' ('.strftime("%T - %d/%m/%y").'):')<CR>
	inoreabbrev todo: <c-r>=printf(&commentstring, ' TODO(vsedov) ('.strftime("%T - %d/%m/%y").'):')<CR>
	inoreabbrev hack: <c-r>=printf(&commentstring, ' HACK(vsedov) ('.strftime("%T - %d/%m/%y").'):')<CR>
	inoreabbrev fixme: <c-r>=printf(&commentstring, ' FIXME(vsedov) ('.strftime("%T - %d/%m/%y").'):')<CR>
	inoreabbrev bug: <c-r>=printf(&commentstring, ' BUG(vsedov) ('.strftime("%T - %d/%m/%y").'):')<CR>
	inoreabbrev :tdate: <c-r>=strftime("%Y-%m-%d")<cr>

	inoreabbrev funciton function
	inoreabbrev asycn async
	inoreabbrev cosnt     const
	inoreabbrev ehco echo
	inoreabbrev flase     false
	inoreabbrev functoin  function
	inoreabbrev ocnst     const
	inoreabbrev retunr    return
	inoreabbrev reutnr    return
	inoreabbrev reutrn    return
	inoreabbrev strign    string
	inoreabbrev treu true
	inoreabbrev undefiend undefined
	inoreabbrev lod ಠ_ಠ
	inoreabbrev sadface ʘ︵ʘ
	inoreabbrev pandaman 🐼
	inoreabbrev teh the
	inoreabbrev Adn And
	inoreabbrev adn and
	inoreabbrev Execture Execute
	inoreabbrev execture execute
	inoreabbrev Exectures Executes
	inoreabbrev exectures executes
	inoreabbrev Nubmer Number
	inoreabbrev nubmer    number
	inoreabbrev Nubmers   Numbers
	inoreabbrev nubmers   numbers
	inoreabbrev Reponse   Response
	inoreabbrev reponse   response
	inoreabbrev Reponses  Responses
	inoreabbrev reponses  responses
	inoreabbrev Resovle   Resolve
	inoreabbrev resovle   resolve
	inoreabbrev Resovled  Resolved
	inoreabbrev resovled  resolved
	inoreabbrev Resovles  Resolves
	inoreabbrev resovles  resolves
	inoreabbrev Resovling Resolving
	inoreabbrev resovling resolving
	inoreabbrev Serach    Search
	inoreabbrev serach    search
	inoreabbrev Serached  Searched
	inoreabbrev serached  searched
	inoreabbrev Seraches  Searches
	inoreabbrev seraches  searches
	inoreabbrev Seraching Searching
	inoreabbrev seraching searching
	inoreabbrev Shuold    Should
	inoreabbrev shuold    should
	inoreabbrev Soruce    Source
	inoreabbrev soruce    source
	inoreabbrev Soruces   Sources
	inoreabbrev soruces   sources
	inoreabbrev Sorucing  Sourcing
	inoreabbrev sorucing  sourcing
	inoreabbrev udner     under
	inoreabbrev Udner     Under
	inoreabbrev Udpate    Update
	inoreabbrev udpate    update
	inoreabbrev Udpated   Updated
	inoreabbrev udpated   updated
	inoreabbrev Udpates   Updates
	inoreabbrev udpates   updates
	inoreabbrev Udpating  Updating
	inoreabbrev udpating  updating
	inoreabbrev Widnow    Window
	inoreabbrev widnow    window
	inoreabbrev WidnoWing Windowing
	inoreabbrev Widnows   Windows
	inoreabbrev widnows   windows
	inoreabbrev rtfm read the fucking manual
	inoreabbrev Iam I am
	inoreabbrev Im I am
	inoreabbrev TEh The
	inoreabbrev THat That
	inoreabbrev THe The
	inoreabbrev Teh The
	inoreabbrev Theyare they are
	inoreabbrev Youre you are
	inoreabbrev abotu about
	inoreabbrev aboutit about it
	inoreabbrev acn can
	inoreabbrev aer are
	inoreabbrev agian again
	inoreabbrev ahev have
	inoreabbrev ahve have
	inoreabbrev alos also
	inoreabbrev alot a lot
	inoreabbrev alse else
	inoreabbrev alsot also
	inoreabbrev amde made
	inoreabbrev amke make
	inoreabbrev amkes makes
	inoreabbrev anbd and
	inoreabbrev andd and
	inoreabbrev anf and
	inoreabbrev ans and
	inoreabbrev aobut about
	inoreabbrev aslo also
	inoreabbrev asthe as the
	inoreabbrev atthe at the
	inoreabbrev awya away
	inoreabbrev aywa away
	inoreabbrev bakc back
	inoreabbrev baout about
	inoreabbrev bcak back
	inoreabbrev beacuse because
	inoreabbrev becuase because
	inoreabbrev bve be
	inoreabbrev cant cannot
	inoreabbrev chaneg change
	inoreabbrev chanegs changes
	inoreabbrev chekc check
	inoreabbrev chnage change
	inoreabbrev chnaged changed
	inoreabbrev chnages changes
	inoreabbrev claer clear
	inoreabbrev cmo com
	inoreabbrev cna can
	inoreabbrev coudl could
	inoreabbrev cpoy copy
	inoreabbrev dael deal
	inoreabbrev didnot did not
	inoreabbrev didnt did nott
	inoreabbrev diea idea
	inoreabbrev doens does
	inoreabbrev doese does
	inoreabbrev doesnt does not
	inoreabbrev doign doing
	inoreabbrev doimg doing
	inoreabbrev donig doing
	inoreabbrev dont do not
	inoreabbrev eahc each
	inoreabbrev efel feel
	inoreabbrev ehlp help
	inoreabbrev ehr her
	inoreabbrev emial email
	inoreabbrev ened need
	inoreabbrev enxt next
	inoreabbrev esle else
	inoreabbrev ew we
	inoreabbrev eyar year
	inoreabbrev eyt yet
	inoreabbrev fatc fact
	inoreabbrev fidn find
	inoreabbrev fiel file
	inoreabbrev firts first
	inoreabbrev flase false
	inoreabbrev fo of
	inoreabbrev fomr form
	inoreabbrev fora for a
	inoreabbrev forthe for the
	inoreabbrev foudn found
	inoreabbrev frmo from
	inoreabbrev fro for
	inoreabbrev frome from
	inoreabbrev fromthe from the
	inoreabbrev fwe few
	inoreabbrev gerat great
	inoreabbrev gievn given
	inoreabbrev goign going
	inoreabbrev gonig going
	inoreabbrev gruop group
	inoreabbrev grwo grow
	inoreabbrev haev have
	inoreabbrev hasa has a
	inoreabbrev havea have a
	inoreabbrev hda had
	inoreabbrev hge he
	inoreabbrev hlep help
	inoreabbrev holf hold
	inoreabbrev hsa has
	inoreabbrev hsi his
	inoreabbrev htan than
	inoreabbrev htat that
	inoreabbrev hte the
	inoreabbrev htem them
	inoreabbrev hten then
	inoreabbrev htere there
	inoreabbrev htese these
	inoreabbrev htey they
	inoreabbrev hting thing
	inoreabbrev htink think
	inoreabbrev htis this
	inoreabbrev hvae have
	inoreabbrev hvaing having
	inoreabbrev hvea have
	inoreabbrev hwich which
	inoreabbrev hwo how
	inoreabbrev idae idea
	inoreabbrev idaes ideas
	inoreabbrev ihs his
	inoreabbrev ina in a
	inoreabbrev inot into
	inoreabbrev inteh in the
	inoreabbrev inthe in the
	inoreabbrev inthese in these
	inoreabbrev inthis in this
	inoreabbrev inwhich in which
	inoreabbrev isthe is the
	inoreabbrev isze size
	inoreabbrev itis it is
	inoreabbrev itwas it was
	inoreabbrev iused used
	inoreabbrev iwll will
	inoreabbrev iwth with
	inoreabbrev jstu just
	inoreabbrev jsut just
	inoreabbrev knwo know
	inoreabbrev knwon known
	inoreabbrev knwos knows
	inoreabbrev konw know
	inoreabbrev konwn known
	inoreabbrev konws knows
	inoreabbrev kwno know
	inoreabbrev laod load
	inoreabbrev lastr last
	inoreabbrev layed laid
	inoreabbrev liek like
	inoreabbrev liekd liked
	inoreabbrev liev live
	inoreabbrev likly likely
	inoreabbrev ling long
	inoreabbrev liuke like
	inoreabbrev loev love
	inoreabbrev lsat last
	inoreabbrev lveo love
	inoreabbrev lvoe love
	inoreabbrev mcuh much
	inoreabbrev mear mere
	inoreabbrev mial mail
	inoreabbrev mkae make
	inoreabbrev mkaes makes
	inoreabbrev mkea make
	inoreabbrev moeny money
	inoreabbrev mroe more
	inoreabbrev msut must
	inoreabbrev muhc much
	inoreabbrev muts must
	inoreabbrev mysefl myself
	inoreabbrev myu my
	inoreabbrev nad and
	inoreabbrev niether neither
	inoreabbrev nkow know
	inoreabbrev nkwo know
	inoreabbrev nmae name
	inoreabbrev nowe now
	inoreabbrev nto not
	inoreabbrev nver never
	inoreabbrev nwe new
	inoreabbrev nwo now
	inoreabbrev ocur occur
	inoreabbrev ofa of a
	inoreabbrev ofits of its
	inoreabbrev ofthe of the
	inoreabbrev oging going
	inoreabbrev ohter other
	inoreabbrev omre more
	inoreabbrev oneof one of
	inoreabbrev onthe on the
	inoreabbrev onyl only
	inoreabbrev ot to
	inoreabbrev otehr other
	inoreabbrev otu out
	inoreabbrev outof out of
	inoreabbrev owrk work
	inoreabbrev owuld would
	inoreabbrev paide paid
	inoreabbrev peice piece
	inoreabbrev puhs push
	inoreabbrev pwoer power
	inoreabbrev rela real
	inoreabbrev rulle rule
	inoreabbrev rwite write
	inoreabbrev sasy says
	inoreabbrev seh she
	inoreabbrev shoudl should
	inoreabbrev sitll still
	inoreabbrev sleect select
	inoreabbrev smae same
	inoreabbrev smoe some
	inoreabbrev sned send
	inoreabbrev soem some
	inoreabbrev sohw show
	inoreabbrev soze size
	inoreabbrev stnad stand
	inoreabbrev stpo stop
	inoreabbrev si is
	inoreabbrev syas says
	inoreabbrev ta at
	inoreabbrev tahn than
	inoreabbrev taht that
	inoreabbrev tath that
	inoreabbrev tehir their
	inoreabbrev tehn then
	inoreabbrev tehre there
	inoreabbrev tehy they
	inoreabbrev tghe the
	inoreabbrev tghis this
	inoreabbrev thanit than it
	inoreabbrev thansk thanks
	inoreabbrev thast that
	inoreabbrev thats that is
	inoreabbrev thatthe that the
	inoreabbrev theh then
	inoreabbrev theri their
	inoreabbrev theyare they are
	inoreabbrev thgat that
	inoreabbrev thge the
	inoreabbrev thier their
	inoreabbrev thign thing
	inoreabbrev thme them
	inoreabbrev thn then
	inoreabbrev thna than
	inoreabbrev thne then
	inoreabbrev thnig thing
	inoreabbrev thre there
	inoreabbrev thsi this
	inoreabbrev thsoe those
	inoreabbrev thta that
	inoreabbrev thyat that
	inoreabbrev thye they
	inoreabbrev ti it
	inoreabbrev tiem time
	inoreabbrev tihs this
	inoreabbrev timne time
	inoreabbrev tiome time
	inoreabbrev tje the
	inoreabbrev tjhe the
	inoreabbrev tkae take
	inoreabbrev tkaes takes
	inoreabbrev tkaing taking
	inoreabbrev todya today
	inoreabbrev tothe to the
	inoreabbrev towrad toward
	inoreabbrev tthe the
	inoreabbrev ture true
	inoreabbrev twpo two
	inoreabbrev tyhat that
	inoreabbrev tyhe they
	inoreabbrev uise use
	inoreabbrev untill until
	inoreabbrev veyr very
	inoreabbrev vrey very
	inoreabbrev waht what
	inoreabbrev wass was
	inoreabbrev watn want
	inoreabbrev weas was
	inoreabbrev wehn when
	inoreabbrev werre were
	inoreabbrev whcih which
	inoreabbrev wherre where
	inoreabbrev whic which
	inoreabbrev whihc which
	inoreabbrev whn when
	inoreabbrev whta what
	inoreabbrev wih with
	inoreabbrev wihch which
	inoreabbrev wiht with
	inoreabbrev willbe will be
	inoreabbrev willk will
	inoreabbrev witha with a
	inoreabbrev withe with
	inoreabbrev withh with
	inoreabbrev withit with it
	inoreabbrev witht with
	inoreabbrev withthe with the
	inoreabbrev witn with
	inoreabbrev wiull will
	inoreabbrev wnat want
	inoreabbrev wnats wants
	inoreabbrev woh who
	inoreabbrev wohle whole
	inoreabbrev wokr work
	inoreabbrev woudl would
	inoreabbrev wrod word
	inoreabbrev wroet wrote
	inoreabbrev wrok work
	inoreabbrev wtih with
	inoreabbrev wuould would
	inoreabbrev wya way
	inoreabbrev yaer year
	inoreabbrev yera year
	inoreabbrev yoiu you
	inoreabbrev yoru your
	inoreabbrev youare you are
	inoreabbrev youre you are
	inoreabbrev youve you have
	inoreabbrev yrea year
	inoreabbrev ytou you
	inoreabbrev yuo you
	inoreabbrev realli really
	inoreabbrev sukc suck
	inoreabbrev zpeling spelling
	inoreabbrev yuor your
]])
