{...}
: {
  programs.newsboat = {
    enable = true;
    browser = "mpv";

    extraConfig = ''
      color info black cyan
      color listfocus black green
      color listfocus_unread black green
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
      {
        title = "---Youtube---";
        url = "";
      }
      {
        tags = ["youtube"];
        url = "https://www.youtube.com/feeds/videos.xml?channel_id=UChbVFLcb9f5L6oZaGtztbCg";
      }
      {
        tags = ["youtube"];
        url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC_O58Rr2DOskJvs9bArpLkQ";
      }
    ];
  };
}
