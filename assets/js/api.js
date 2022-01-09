const API = {
  shortenLink: url => {
    return fetch("/links", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ link: { url: url } })
    });
  }
};

export default API;
