{ pkgs, ... }:

let
  openBrowser = pkgs.writeShellScriptBin "newsboat-open-browser" ''
    ${pkgs.util-linux}/bin/setsid -f vieb "$@" >/dev/null 2>&1
  '';

  plainFeeds = [
    "https://bcantrill.dtrace.org/index.xml"
    "https://nullprogram.com/feed/"
    "https://drewdevault.com/blog/index.xml"
    "https://hookrace.net/blog/feed/"
    "https://davidwalsh.name/feed"
    "https://code.dblock.org/feed.xml"
    "https://danluu.com/atom.xml"
    "https://cprss.s3.amazonaws.com/nodeweekly.com.xml"
    "https://domenicoluciani.com/feed.xml"
    "https://www.evanmiller.org/software.xml"
    "https://www.evanmiller.org/news.xml"
    "https://www.evanjones.ca/index.rss"
    "https://evanhahn.com/blog/index.xml"
    "https://ericlippert.com/feed/"
    "https://eli.thegreenplace.net/feeds/all.atom.xml"
    "https://blog.elegantcode.com/feed/"
    "https://darkcoding.net/index.xml"
    "https://glebbahmutov.com/blog/atom.xml"
    "https://words.filippo.io/rss/"
    "https://huonw.github.io/blog/rss.xml"
    "https://henrikwarne.com/feed/"
    "https://research.swtch.com/feed.atom"
    "https://codewithoutrules.com/atom.xml"
    "https://ieftimov.com/index.xml"
    "https://linuxblog.io/feed/"
    "https://jaketrent.com/post/feed.xml"
    "https://jvns.ca/atom.xml"
    "https://blog.reverberate.org/feed.xml"
    "https://www.jeremykun.com/index.xml"
    "https://preshing.com/feed"
    "https://jakewharton.com/atom.xml"
    "https://lea.verou.me/feed.xml"
    "https://hazelweakly.me/atom.xml"
    "https://hoverbear.org/rss.xml"
    "https://www.ashleyarthur.co.uk/index.xml"
    "http://feeds.feedburner.com/kburke"
    "https://mishadoff.com/atom.xml"
    "http://blog.fogus.me/feed.xml"
    "https://blog.muffn.io/posts/index.xml"
    "https://blog.cryptographyengineering.com/feed/"
    "https://matt.might.net/articles/feed.rss"
    "https://maryrosecook.com/blog/feed.xml"
    "https://martinfowler.com/feed.atom"
    "https://blog.rinesi.com/feed/"
    "https://www.nateberkopec.com/feed.xml"
    "https://nshipster.com/feed.xml"
    "https://www.thepolyglotdeveloper.com/blog/index.xml"
    "https://blog.nelhage.com/atom.xml"
    "https://os.phil-opp.com/rss.xml"
    "http://feeds2.feedburner.com/PetrMitrichev"
    "http://blog.pamelafox.org/feeds/posts/default"
    "http://feeds.feedburner.com/rtwilson/blog"
    "http://blog.cleancoder.com/atom.xml"
    "https://akrabat.com/feed/"
    "https://rachelbythebay.com/w/atom.xml"
    "https://www.cs.columbia.edu/~smb/blog/control/blog.xml"
    "https://muffinman.io/atom.xml"
    "http://feeds.feedburner.com/AdventuresInAutomation"
    "https://jelv.is/blog/rss.xml"
    "https://feeds.feedburner.com/TheDailyWtf"
    "https://tania.dev/rss.xml"
    "https://www.yegor256.com/rss.xml"
    "https://una.im/rss.xml"
    "https://blog.rust-lang.org/feed.xml"
    "https://blog.ipfs.tech/index.xml"
    "https://go.dev/blog/feed.atom"
    "https://overreacted.io/rss.xml"
    "https://nesslabs.com/feed"
    "https://hacks.mozilla.org/feed/"
    "https://engineering.fb.com/feed/"
    "http://feeds.feedburner.com/GDBcode"
    "https://engineering.atspotify.com/feed"
    "https://blog.cloudflare.com/rss/"
    "https://engineering.fb.com/tag/instagram/feed/"
    "https://stripe.com/blog/feed.rss"
    "https://blog.x.com/engineering/en_us/blog.rss"
    "https://slack.engineering/feed/"
    "https://engineering.grab.com/feed.xml"
    "https://bigthink.com/feed/"
    "https://newsboat.org/news.atom"
    "https://brooker.co.za/blog/rss.xml"
    "https://www.tunetheweb.com/rss.xml"
    "https://simonwillison.net/atom/everything/"
    "https://devenv.sh/feed_rss_created.xml"
    "https://discourse.nixos.org/c/announcements/8.rss"
    "https://www.devroom.io/feed.xml"
    "https://ariya.io/index.xml"
    "https://chenhuijing.com/feed.xml"
    "https://dragan.rocks/feed.xml"
    "https://erikrunyon.com/feed.xml"
    "https://jsomers.net/blog/feed"
    "https://bun.com/rss.xml"
    "https://www.grepular.com/rss"
    "https://www.joelonsoftware.com/feed/"
    "https://use-the-index-luke.com/blog/feed"
    "https://antirez.com/rss"
    "https://nodevibe.substack.com/feed"
  ];
in
{
  programs.newsboat = {
    enable = true;
    browser = "${openBrowser}/bin/newsboat-open-browser";
    autoReload = true;
    reloadTime = 60;
    extraConfig = builtins.readFile ../../../home/.newsboat/config;
    autoFetchArticles = {
      enable = true;
      onCalendar = "daily";
    };

    urls = map (url: { inherit url; }) plainFeeds ++ [
      {
        url = "https://nodejs.org/en/feed/blog.xml";
        title = "Node.js Official blog";
        tags = [
          "nodejs"
          "js"
          "ts"
        ];
      }
      {
        url = "https://cprss.s3.amazonaws.com/javascriptweekly.com.xml";
        title = "JavaScript Weekly";
        tags = [ "js" ];
      }
      {
        url = "https://v8.dev/blog.atom";
        title = "v8";
        tags = [ "js" ];
      }
      {
        url = "https://steipete.me/rss.xml";
        tags = [ "AI-engineering" ];
      }
      {
        url = "https://www.fiit.stuba.sk/dianie-na-fakulte/rss.html?page_id=2941";
        title = "FIIT STU";
        tags = [ "study" ];
      }
      {
        url = "https://waxy.org/feed/";
        tags = [
          "tech"
          "art"
          "business"
          "culture"
        ];
      }
      {
        url = "https://kubernetes.io/feed.xml";
        tags = [
          "cloud"
          "opensource"
        ];
      }
      {
        url = "https://www.linuxfoundation.org/blog/rss.xml";
        tags = [
          "linux"
          "opensource"
        ];
      }
      {
        url = "https://blog.alexellis.io/rss/";
        tags = [
          "independent"
          "devops"
          "cloud"
          "opensource"
        ];
      }
      {
        url = "http://feeds.feedburner.com/EsnextNews";
        tags = [
          "news"
          "js"
        ];
      }
      {
        url = "https://lucumr.pocoo.org/feed.atom";
        tags = [ "python" ];
      }
      {
        url = "https://chrisdown.name/feed.xml";
        tags = [
          "top"
          "systems-programming"
          "kerkel"
          "linux"
        ];
      }
      {
        url = "https://augmentedcoding.dev/feed.xml";
        tags = [ "ai" ];
      }
      {
        url = "https://fy.blackhats.net.au/rss.xml";
        tags = [
          "top"
          "passkeys"
          "security"
          "fs"
        ];
      }
      {
        url = "https://lukefleed.xyz/rss.xml";
        tags = [
          "top"
          "memory"
        ];
      }
      {
        url = "https://wingolog.org/feed/atom";
        tags = [
          "v8"
          "top"
        ];
      }
    ];
  };
}
