var character = document.getElementById("character");
var block = document.getElementById("block");
var counter = 0;
var bestScore = 0;

// Sample leaderboard data
var leaderboardData = [
  { rank: 1, name: "Player 1", score: 30 },
  { rank: 2, name: "Player 2", score: 20 },
  { rank: 3, name: "Player 3", score: 10 },
  // Add more data as needed
];

function jump() {
  if (character.classList == "animate") {
    return;
  }
  character.classList.add("animate");
  setTimeout(function () {
    character.classList.remove("animate");
  }, 300);
}

var checkDead = setInterval(function () {
  let characterTop = parseInt(
    window.getComputedStyle(character).getPropertyValue("top")
  );
  let blockLeft = parseInt(
    window.getComputedStyle(block).getPropertyValue("left")
  );
  if (blockLeft < 20 && blockLeft > -20 && characterTop >= 130) {
    block.style.animation = "none";
    var score = Math.floor(counter / 100);
    if (score > bestScore) {
      bestScore = score;
      document.getElementById("scorebest").innerHTML = bestScore;
    }
    var playerName = prompt("Game Over. Enter your name:");
    if (playerName) {
      handleNewHighScore(playerName, score);
      updateLeaderboard();
    }
    counter = 0;
    block.style.animation = "block 1s infinite linear";
  } else {
    counter++;
    document.getElementById("scoreSpan").innerHTML = Math.floor(counter / 100);
  }
}, 10);

function handleNewHighScore(playerName, score) {
  // Add new entry to leaderboard data
  leaderboardData.push({ rank: leaderboardData.length + 1, name: playerName, score: score });

  // Sort the leaderboard data based on score (descending order)
  leaderboardData.sort(function (a, b) {
    return b.score - a.score;
  });

  // Truncate the leaderboard data to a maximum of 10 entries
  leaderboardData = leaderboardData.slice(0, 10);
}

function updateLeaderboard() {
  var leaderboardTable = document.getElementById("leaderboard");
  var tbody = leaderboardTable.getElementsByTagName("tbody")[0];
  tbody.innerHTML = ""; // Clear existing rows

  // Add new rows
  for (var i = 0; i < leaderboardData.length; i++) {
    var entry = leaderboardData[i];
    var row = tbody.insertRow();
    var rankCell = row.insertCell();
    var nameCell = row.insertCell();
    var scoreCell = row.insertCell();

    rankCell.textContent = entry.rank;
    nameCell.textContent = entry.name;
    scoreCell.textContent = entry.score;
  }
}

// Call the function to initially populate the leaderboard
updateLeaderboard();