{...}
: {
  programs.newsboat = {
    enable = true;
    browser = "mpv";

    extraConfig = ''
      color info black cyan
      color listfocus green black
      color listfocus_unread green black
    '';

    urls = [
      {
        tags = ["podcast"];
        url = "https://jumble.top/f/trueanonpod.xml";
      }
      {
        tags = ["podcast"];
        url = "https://www.omnycontent.com/d/playlist/aaea4e69-af51-495e-afc9-a9760146922b/4a3ca742-9a68-4850-a727-ab790176c0e9/d04153b0-fc4c-4191-ab18-ab790179c563/podcast.rss";
      }
    ];
  };
}
